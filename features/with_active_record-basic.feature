@db
Feature: Using with ActiveRecord
  In order to generate and validate URL keys in an ActiveRecord::Base object
  A Rails developer
  Wants to include and use UrlKeyedObject
  
  # The most basic use case is for a 5-character ID, stored in the url_key column.
  # 
  # Simply including the UrlKeyedObject::ActiveRecord module is enough. 
  # This makes the url_key attribute protected from mass assignment and read-only.
  Background:
    Given a database, with this table defined:
      """
      create_table :things do |t|
        t.string    :url_key, :null => false
        
        t.timestamps
      end
      """
    And this class:
      """
      class Thing < ActiveRecord::Base
        include UrlKeyedObject::ActiveRecord
      end
      """
  
  Scenario: An unsaved model object with UrlKeyedObject included
    When I make a bare instance:
      """
        @instance = Thing.new
      """
    Then @instance.url_key should be nil
  
  Scenario: A saved model object with UrlKeyedObject included
    When I make and save an instance:
      """
        @instance = Thing.new
        @instance.save!
      """
    Then @instance.url_key should match /[a-z0-9]{5}/
  
  Scenario: Attempting to mass-assign url_key ought to fail
    When I make an instance using mass-assignment:
      """
        @instance = Thing.new(:url_key => 'abcde')
      """
    Then @instance.url_key should be nil
    And a warning should have been logged
  
  Scenario: Attempting to set url_key ought to fail
    When I make an instance using mass-assignment:
      """
        @instance = Thing.new
        @instance.url_key = 'abcde'
      """
    Then @instance.url_key should be nil
    And a warning should have been logged

