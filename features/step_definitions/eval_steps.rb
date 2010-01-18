Given /^this class:$/ do |string|
  eval string
end

When /^I make .+ instance:$/ do |string|
  eval string
end
