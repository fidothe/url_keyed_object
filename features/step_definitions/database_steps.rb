require 'tmpdir'

Given /^a database, with this table defined:$/ do |db_string|
  eval(["class FeatureMigration < ActiveRecord::Migration; def self.up", 
        db_string, "end; end"].join("\n"))
  FeatureMigration.migrate(:up)
end
