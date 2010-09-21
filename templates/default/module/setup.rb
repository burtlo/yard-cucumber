#include YARD::Templates::Helpers::HtmlHelper

def init
  super  
  
  sections.place(:step_transforms).after(:constant_summary)
  sections.place(:step_definitions).after(:step_transforms)
  sections.place(:steps).after(:step_definitions)
  
end


def step_definitions
  
  # For the given step definition find all the constants
    
  @step_defs = object.step_definitions.collect do |stepdef|
    #log.debug "Step Definition #{stepdef} #{stepdef.value}"
    
    constants = stepdef.constants.collect do |stepdef_constant| 
      log.debug "StepDef\#Constant #{stepdef_constant}"
      object.constants.find {|constant| stepdef_constant.to_sym == constant.name }
      #log.debug "StepDef\#Constant #{constants}"
    end
    
    constants.each {|constant| stepdef.value.gsub!(constant.name.to_s,%{<a href="#{url_for(constant)}">#{constant}</a>}) }
    stepdef
  end
  
  # TODO: For the given step definitions find all the steps
  # 
  
  erb(:step_definitions)
end

def steps
  
  # For all the features, and scenarios, find the steps and then see if they match the step definition...
  
  
  
  erb(:steps)
  
end