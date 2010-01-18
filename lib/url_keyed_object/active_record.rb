module UrlKeyedObject
  module ActiveRecord
    # --
    # the stuff that actually gets included.
    # comment included for my benefit, in case I forget (quite likely)
    # ++
    
    def to_param
      url_key
    end
    
    # --
    # Validations
    # ++
    
    def self.included(model)
      model.class_eval do
        # validates_presence_of :url_key
        # validates_uniqueness_of :url_key
        
        before_create :generate_valid_url_key
        
        attr_readonly :url_key
        attr_protected :url_key
      end
    end
    
    protected
    
    def generate_valid_url_key
      new_url_key = UrlKeyedObject.generate_unchecked_url_key
      while !self.valid_url_key?(new_url_key) do
        new_url_key = UrlKeyedObject.generate_unchecked_url_key
      end
      self.url_key = new_url_key
    end
    
    def valid_url_key?(url_key)
      self.class.find_by_url_key(url_key).nil?
    end
  end
end