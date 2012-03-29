require 'spec_helper'

require 'url_keyed_object/active_record'
require 'fixtures/url_keyable_model'

class UrlKeyedModel < UrlKeyableModel
  extend UrlKeyedObject::ActiveRecord

  has_url_key
end

describe UrlKeyedObject::ActiveRecord do
  let(:url_keyed_object) { UrlKeyedModel.new }

  it "protects URL keys from mass-assignment" do
    url_keyed_object = UrlKeyedModel.new(:url_key => 'woo')

    url_keyed_object.url_key.should be_nil
  end

  it "does not allow URL keys to be set" do
    url_keyed_object.url_key = 'dfghj'

    url_keyed_object.url_key.should be_nil
  end

  it "returns the contents of the url_key column for to_param" do
    url_keyed_object.stubs(:url_key).returns('hello')

    url_keyed_object.to_param.should == 'hello'
  end

  describe "ensuring unique URL keys get created" do
    let(:ar_helper) { UrlKeyedObject::ActiveRecord::Helper.new(UrlKeyedModel, :url_key, 5) }

    it "can verify that a URL key is valid" do
      UrlKeyedModel.expects(:find_by_url_key).with('a_url').returns(nil)

      ar_helper.valid_url_key?('a_url').should be_true
    end

    it "can verify that a URL key is not valid" do
      UrlKeyedModel.expects(:find_by_url_key).with('a_url').returns(UrlKeyedModel.new)

      ar_helper.valid_url_key?('a_url').should be_false
    end

    it "keeps attempting to create a URL key until one is valid" do
      url_keyed_object = UrlKeyedModel.new

      UrlKeyedObject.expects(:generate_checked_url_key).yields('a2url').returns('a2url')
      ar_helper.expects(:valid_url_key?).with('a2url').returns(true)

      ar_helper.generate_valid_url_key(url_keyed_object)

      url_keyed_object.url_key.should == 'a2url'
    end

    it "uses a before_create callback to ensure that a URL key is created" do
      UrlKeyedModel.url_key_helper.expects(:generate_valid_url_key).with(url_keyed_object)

      url_keyed_object.save
    end
  end
end
