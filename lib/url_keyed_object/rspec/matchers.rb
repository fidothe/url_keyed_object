module UrlKeyedObject
  module RSpec
    module Matchers
      def have_url_key
        UrlKeyedObjectMatcher.new
      end

      class UrlKeyedObjectMatcher
        def matches?(subject)
          @subject = subject
          @subject.class.respond_to?(:url_key_helper) && @subject.respond_to?(:generate_valid_url_key)
        end

        def description
          "have declared has_url_key"
        end

        def failure_message
          "expected #{@subject.class.name} to have declared has_url_key"
        end

        def negative_failure_message
          "expected #{@subject.class.name} to have NOT declared has_url_key"
        end
      end
    end
  end
end
