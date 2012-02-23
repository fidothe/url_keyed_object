require 'url_keyed_object'
require 'active_support/concern'

module UrlKeyedObject
  module ActiveRecord
    def has_url_key(opts = {})
      url_key_column = opts.has_key?(:column) ? opts[:column] : :url_key
      url_key_length = opts.has_key?(:length) ? opts[:length] : 5

      include UrlKeyedObject::ActiveRecord::Extensions

      attr_protected url_key_column
      before_create :generate_valid_url_key

      @url_key_helper = UrlKeyedObject::ActiveRecord::Helper.new(self, url_key_column, url_key_length)

      define_method("#{url_key_column}=") { |value| logger.warn("Attempt to set ##{url_key_column}!") if self.respond_to?(:logger); nil }
    end

    class Helper
      attr_reader :klass, :column, :length

      def initialize(klass, column, length)
        @klass = klass
        @column = column
        @length = length
      end

      def generate_valid_url_key(instance)
        new_url_key = UrlKeyedObject.generate_checked_url_key(length) { |value| valid_url_key?(value) }
        instance.send(:write_attribute, column, new_url_key)
      end

      def valid_url_key?(url_key)
        klass.send("find_by_#{column}", url_key).nil?
      end
    end

    module Extensions
      extend ActiveSupport::Concern

      def to_param
        send self.class.url_key_helper.column
      end

      module ClassMethods
        def url_key_helper
          @url_key_helper
        end
      end

    protected
      def generate_valid_url_key
        self.class.url_key_helper.generate_valid_url_key(self)
      end
    end
  end
end
