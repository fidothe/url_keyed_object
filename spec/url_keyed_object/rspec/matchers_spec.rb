require 'spec_helper'

require 'fixtures/url_keyable_model'
require 'url_keyed_object/active_record'
require 'url_keyed_object/rspec/matchers'

describe "Verifying that a model object has been set up with has_url_key" do
  include UrlKeyedObject::RSpec::Matchers

  before(:each) do
    @klass = Class.new(UrlKeyableModel)
    @klass.extend UrlKeyedObject::ActiveRecord
  end

  it "provides a matcher which verifies positively" do
    @klass.has_url_key

    @klass.new.should have_url_key
  end

  it "provides a matcher which verifies negatively" do
    @klass.new.should_not have_url_key
  end
end
