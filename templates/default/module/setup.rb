
def init
  super  
  
  sections.place(:step_transforms).after(:constant_summary)
  sections.place(:step_definitions).after(:step_transforms)
  sections.place(:steps).after(:step_definitions)
  
  log.debug "Step Definition List:"
  object.step_definitions.each {|stepdef| log.debug "Step definition #{stepdef}"}
  
  log.debug "Step Tranform List:"
  object.step_transforms.each {|transform| log.debug "Step transform #{transform}"}
    
  log.debug "Step List:"
  object.steps.each {|step| log.debug "Step #{step}"}
  
  
  log.debug "Children:"
  object.children.each {|child| log.debug "Child: #{child} #{child.type}"}
  
end
