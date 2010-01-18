Then /^:([a-z_0-9]+) should be nil$/ do |method|
  @instance.send(method).should be_nil
end

Then /^:([a-z_0-9]+) should match \/(.+)\/$/ do |method, regex|
  @instance.send(method).should match(regex)
end
