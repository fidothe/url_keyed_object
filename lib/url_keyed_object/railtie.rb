require 'url_keyed_object/active_record'

module UrlKeyedObject
  class Railtie
    initializer 'url_keyed_object.active_record_hook' do
      ActiveRecord::Base.send :include, UrlKeyedObject::ActiveRecord
    end
  end
end