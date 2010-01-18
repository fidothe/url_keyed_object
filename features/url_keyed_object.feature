@db
Feature: Using with ActiveRecord
  In order to generate and validate URL keys in an ActiveRecord::Base object
  A Rails developer
  Wants to include and use UrlKeyedObject
  
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
  
  Scenario: An unsaved model object with UrlKeyedObject included
    When I make and save an instance:
      """
        @instance = Thing.new
        @instance.save!
      """
    Then @instance.url_key should match /[a-z0-9]{5}/
  