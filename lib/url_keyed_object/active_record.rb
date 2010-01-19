require 'url_keyed_object'

module UrlKeyedObject
  module ActiveRecord
    # --
    # the stuff that actually gets included.
    # comment included for my benefit, in case I forget (quite likely)
    # ++
    
    def to_param
      url_key
    end
    
    def url_key=(value)
      logger.warn('Attempt to set #url_key!')
      nil
    end
    
    # --
    # Validations
    # ++
    
    def self.included(model)
      model.class_eval do
        before_create :generate_valid_url_key
      end
    end
    
    protected
    
    def generate_valid_url_key
      new_url_key = UrlKeyedObject.generate_checked_url_key { |value| self.valid_url_key?(value) }
      write_attribute(:url_key, new_url_key)
    end
    
    def valid_url_key?(url_key)
      self.class.find_by_url_key(url_key).nil?
    end
  end
end