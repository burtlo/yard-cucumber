

CUSTOMER = /(an?|the) customer/

Transform /^an? customer$/ do |customer|
  "a transformed customer"
end

Transform /^the customer$/ do |customer|
  "the transformed customer"
end

Given /^that (#{CUSTOMER}) is a valid customer$/ do |customer|
  pending "Customer #{customer} validation"  
end

When /^a customer logs in as username '([^']+)' with password '([^']+)'$/ do |username,password|
  pending "Customer logs in with #{username} and #{password}"
end

Then /^I expect them to have logged in successfully $/ do 
  pending "Validation that the customer has logged in successfully"  
end

When /^the customer logs out$/ do
  pending
end

Then /^I expect the customer to be shown the logout page$/ do 
  pending
end