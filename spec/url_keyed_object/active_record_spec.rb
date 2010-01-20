require 'spec_helper'
require 'active_record'
require 'tmpdir'
require 'fileutils'
require 'logger'

class SpecMigration < ActiveRecord::Migration
  def self.up
    create_table :things do |t|
      t.string    :url_key, :null => false
      
      t.timestamps
    end
  end
end

describe UrlKeyedObject::ActiveRecord do
  before(:all) do
    @db_dir = ::Dir.mktmpdir
    begin
      # Create the SQLite database
      ActiveRecord::Base.establish_connection({'adapter' => 'sqlite3',
      'database' => "#{@db_dir}/spec.sqlite3", 'pool' => 5, 'timeout' => 5000
      })
      ActiveRecord::Base.connection
    rescue
      $stderr.puts $!, *($!.backtrace)
      $stderr.puts "Couldn't create database for #{"#{@db_dir}/feature.sqlite3".inspect}"
    end
    
    SpecMigration.migrate(:up)
    
    @url_keyed_class = Class.new(ActiveRecord::Base)
    @url_keyed_class.class_eval do
      set_table_name 'things'
      def self.name
        'UrlKeyedObjectMock'
      end
      
      acts_as_url_keyed
    end
    
    ActiveRecord::Base.logger = Logger.new(STDERR)
  end
  
  after(:all) do
    ActiveRecord::Base.connection.disconnect!
    FileUtils.remove_entry_secure @db_dir
  end
  
  it "should protect URL keys from mass-assignment" do
    url_keyed_object = @url_keyed_class.new(:url_key => 'woo')
    
    url_keyed_object.url_key.should be_nil
  end
  
  it "should not allow URL keys to be set" do
    url_keyed_object = @url_keyed_class.new
    
    url_keyed_object.url_key = 'dfghj'
    
    url_keyed_object.url_key.should be_nil
  end
  
  describe "ensuring unique URL keys get created " do
    it "should be able to verify that a URL key is valid" do
      @url_keyed_class.expects(:find_by_url_key).with('a_url').returns(nil)
      url_keyed_object = @url_keyed_class.new
      
      @url_keyed_class.publicize_methods do
        url_keyed_object.valid_url_key?('a_url').should be_true
      end
    end
    
    it "should be able to verify that a URL key is not valid" do
      @url_keyed_class.expects(:find_by_url_key).with('a_url').returns(@url_keyed_class.new)
      url_keyed_object = @url_keyed_class.new
      
      @url_keyed_class.publicize_methods do
        url_keyed_object.valid_url_key?('a_url').should be_false
      end
    end
    
    it "should be able to keep attempting to create a URL key until one is valid" do
      url_keyed_object = @url_keyed_class.new
      
      UrlKeyedObject.expects(:generate_checked_url_key).yields('a2url').returns('a2url')
      url_keyed_object.expects(:valid_url_key?).with('a2url').returns(true)
      
      @url_keyed_class.publicize_methods do
        url_keyed_object.generate_valid_url_key
        
        url_keyed_object.url_key.should == 'a2url'
      end
    end
    
    it "should use a before_create callback to ensure that a URL key is created" do
      @url_keyed_class.should use_method(:generate_valid_url_key).for_callback(:before_create)
    end
  end
end