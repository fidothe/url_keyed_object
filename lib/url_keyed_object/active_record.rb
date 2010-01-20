require 'url_keyed_object'
require 'active_record'

module UrlKeyedObject
  module ActiveRecord
    # def url_key=(value)
    #   logger.warn('Attempt to set #url_key!')
    #   nil
    # end
    
    
    module ClassMethods
      def url_key_column
        @url_key_column ||= :url_key
      end
      
      def url_key_length
        @url_key_length ||= 5
      end
      
      def acts_as_url_keyed(opts = {})
        attr_writer :url_key_length
        
        @url_key_column = opts[:url_key_column] if opts.has_key?(:url_key_column)
        @url_key_length = opts[:url_key_length] if opts.has_key?(:url_key_length)
        
        before_create :generate_valid_url_key
        
        include InstanceMethods
        
        define_method("#{url_key_column}=") { |value| logger.warn("Attempt to set ##{url_key_column}!"); nil }
      end
    end
    
    module InstanceMethods
      protected
      
      def generate_valid_url_key
        new_url_key = UrlKeyedObject.generate_checked_url_key(url_key_length) { |value| self.valid_url_key?(value) }
        write_attribute(url_key_column, new_url_key)
      end
      
      def valid_url_key?(url_key)
        self.class.send("find_by_#{url_key_column}", url_key).nil?
      end
      
      def url_key_column
        self.class.url_key_column
      end
      
      def url_key_length
        self.class.url_key_length
      end
      
      
      def to_param
        send url_key_column
      end
    end
    
    def self.included(model_class)
      model_class.extend ClassMethods
    end
  end
end

ActiveRecord::Base.send :include, UrlKeyedObject::ActiveRecord
