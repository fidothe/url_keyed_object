Feature: Using for things which are URL key-like
  In order to generate and validate URL key-like data in a plain Ruby object
  A Ruby developer
  Wants to use UrlKeyedObject
  
  # If you want to generate URL key values without validating them it's really easy
  Scenario: Generating a URL key value
    When I make a call to generate a URL key:
      """
      @value = UrlKeyedObject.generate_unchecked_url_key
      """
    Then @value should match /^[a-z0-9]{5}$/
    
  Scenario: Generating and validating a URL key value as part of object initialisation
    Given this class:
      """
        class HasOpaqueId
          class << self
            def instances
              @instances ||= []
            end
          end
          
          attr_reader :id
          
          def initialize
            @id = UrlKeyedObject.generate_checked_url_key do |id_value|
              is_this_a_valid_id?(id_value)
            end
            self.class.instances << self
          end
          
          private
          
          def is_this_a_valid_id?(id_value)
            self.class.instances.select { |obj| obj.id == id_value }.empty?
          end
        end
      """
    When I make a new instance:
      """
        @object_with_id = HasOpaqueId.new
      """
    Then @object_with_id.id should match /^[a-z0-9]{5}$/
    
  Scenario: Generating a URL key value of arbitrary length
    When I make a call to generate a URL key:
      """
      @value = UrlKeyedObject.generate_unchecked_url_key(18)
      """
    Then @value should match /^[a-z0-9]{18}$/
  
  Scenario: Generating and validating a URL key value of arbitrary length
  When I make a call to generate a valid URL key (with an admittedly nonsensical validation block):
    """
    @value = UrlKeyedObject.generate_checked_url_key(18) { |value| value.length == 18 }
    """
  Then @value should match /^[a-z0-9]{18}$/
