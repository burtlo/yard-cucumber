Transform /^#{ORDER}$/ do |order|
  order
end

Transform /^background$/ do |background|
  "background"
end

Transform /^scenario$/ do |scenario|
  "scenario"
end

Given /^this (scenario|background|#{ORDER}) step$/ do |step|
  pending "step #{order}"
end