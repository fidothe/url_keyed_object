Given /^this class:$/ do |string|
  eval string
end

When /^I (?:make|do) .+:$/ do |string|
  eval string
end

Then /^(@[a-zA-Z_0-9]+)\.([a-zA-Z_0-9?!]+) should match \/(.+)\/$/ do |ivar, method, regex|
  instance_variable_get(ivar).send(method).should match(regex)
end

Then /^(@[a-zA-Z_0-9]+) should match \/(.+)\/$/ do |ivar, regex|
  instance_variable_get(ivar).should match(regex)
end

Then /^(@[a-zA-Z_0-9]+)\.([a-zA-Z_0-9?!]+) should be (.+)$/ do |ivar, method, value|
  instance_variable_get(ivar).send(method).should send("be_#{value}")
end
