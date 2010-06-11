require 'url_keyed_object/active_record'

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend UrlKeyedObject::ActiveRecordHook
end