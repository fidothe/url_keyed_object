lib_path = File.expand_path('../../lib', __FILE__)
$:.unshift(lib_path) unless $:.include?(lib_path)

require 'url_keyed_object'

RSpec.configure do |config|
  config.mock_with :mocha
end

RSpec::Matchers.define :use_method do |method|
  chain :for_callback do |callback|
    @callback = callback
  end

  match do |model_class|
    model_class.send("#{@callback.to_s}_callback_chain").find(method)
  end
end

class Class
  def publicize_methods
    saved_private_instance_methods = self.private_instance_methods
    saved_protected_instance_methods = self.protected_instance_methods
    self.class_eval do
      public *saved_private_instance_methods
      public *saved_protected_instance_methods
    end

    yield

    self.class_eval do
      private *saved_private_instance_methods
      protected *saved_protected_instance_methods
    end
  end
end
