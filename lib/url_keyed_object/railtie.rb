require 'rails'
require 'url_keyed_object/active_record'

module UrlKeyedObject
  class Railtie < Rails::Railtie
    initializer 'url_keyed_object.active_record_hook', :after => :preload_frameworks do
      ::ActiveRecord::Base.extend UrlKeyedObject::ActiveRecord
    end
  end
end
