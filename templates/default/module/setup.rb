include Helpers::ModuleHelper

def init
  super
  sections.place(:steps).after(:constant_summary)
  #puts "Children List:"
  #object.children.each {|child| puts "#{child} #{child.type}"}

end
