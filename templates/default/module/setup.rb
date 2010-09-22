#include YARD::Templates::Helpers::HtmlHelper

def init
  super  
  sections.place(:features).after(:constant_summary)
  sections.place(:scenarios).after(:features)
  sections.place(:steps).after(:scenarios)
  sections.place(:step_transforms).after(:steps)
  sections.place(:step_definitions).after(:step_transforms)
  
end


def step_definitions
  
  # For the given step definition find all the constants
    
  object.step_definitions.each do |stepdef|
    
    stepdef.constants = stepdef.value.scan(/\#\{([^\}]+)\}/).flatten.collect do |stepdef_constant| 
      log.debug "StepDef\#Constant #{stepdef_constant}"
      object.constants.find {|constant| stepdef_constant.to_sym == constant.name }
    end
    
    stepdef.constants.each {|constant| stepdef.value_as_link = stepdef.value.gsub(constant.name.to_s,%{<a href="#{url_for(constant)}">#{constant}</a>}) }
    
  end
  
  @step_defs = object.step_definitions
  
  # TODO: For the given step definitions find all the steps
  # 
  
  erb(:step_definitions)
end

def steps
  
  # For all the features, and scenarios, find the steps and then see if they match the step definition...
  
  object.steps.each do |step|
    
    # TODO: Should replace the constants with their values as well
    # TODO: Should handle when has two definitions
    object.step_definitions.each do |step_def|
      log.debug "Looking for a match against #{step_def.value.gsub(/^\/|\/$/,'')}"
      step.definition = step_def if step =~ /#{step_def.value}/
    end
    
  end
  
  
  erb(:steps)
  
end