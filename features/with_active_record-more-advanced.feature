@db
Feature: More advanced usage with ActiveRecord
  In order to generate and validate non-standard URL keys in an ActiveRecord::Base model in a Rails project
  A Rails developer
  Wants to include and use UrlKeyedObject

  # The default case is for a 5-character ID, stored in the url_key column.
  # Here we have an existing column we want to re-use, and we want a longer URL key
  #
  # calling acts_as_url_keyed and setting a couple of options is all that's needed. 
  Background:
    Given a database, with this table defined:
      """
      create_table :advanced_things do |t|
        t.string    :opaque_id, :null => false

        t.timestamps
      end
      """
    And this class:
      """
      class AdvancedThing < ActiveRecord::Base
        has_url_key :column => :opaque_id, :length => 8
      end
      """

  Scenario: An unsaved model object with UrlKeyedObject included
    When I make a bare instance:
      """
        @instance = AdvancedThing.new
      """
    Then @instance.opaque_id should be nil

  Scenario: A saved model object with an 8-character URL key on #opaque_id
    When I make and save an instance:
      """
        @instance = AdvancedThing.new
        @instance.save!
      """
    Then @instance.opaque_id should match /^[a-z0-9]{8}$/

  Scenario: Attempting to mass-assign opaque_id ought to fail
    When I make an instance using mass-assignment:
      """
        @instance = AdvancedThing.new(:opaque_id => 'abcde')
      """
    Then @instance.opaque_id should be nil

  Scenario: Attempting to set opaque_id ought to fail
    When I make an instance and set the value of opaque_id manually:
      """
        @instance = AdvancedThing.new
        @instance.opaque_id = 'abcde'
      """
    Then @instance.opaque_id should be nil
    And a warning should have been logged

