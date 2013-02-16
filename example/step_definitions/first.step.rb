Transform /^#{ORDER}$/ do |order|
  order
end

Transform /^background$/ do |background|
  "background"
end

#
# This step transform converts "scenario" to "scenario"
# 
Transform /^scenario$/ do |scenario|
  "scenario"
end

#
# This step definition is all about steps
# 
Given /^this (scenario|background|#{ORDER}) step$/ do |step|
  puts "step #{order}"
end