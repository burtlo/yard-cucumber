module YARD::CodeObjects
  
  #
  # Steps, as implemented in the Feature file
  #
  class StepImplementationObject < Base
	  attr_reader :value
	  attr_reader :predicate
	
	  def value=(value)
      @value = format_source(value)
    end
  end
  
  #
  # StepDefinitions, as implemented in a ruby file
  #
  class StepDefinitionObject < Base

    attr_reader :value
	  attr_reader :predicate
	  
	  def constants
	    value.scan(/\#\{([^\}]+)\}/).flatten
    end
	
    def value=(value)
      @value = format_source(value)
    end
  end

  #
  # Transforms
  #
  class StepTransformObject < Base
    attr_reader :value
    
    def value=(value)
      @value = format_source(value)
    end
  end
  
  #
  # Allow for steps and step definitions to be available on the NamespaceObject
  #  
  NamespaceObject.class_eval do

    attr_accessor :steps

    def steps(opts = {})
      children.select {|child| child.type == :step }
    end

    attr_accessor :step_definitions

    def step_definitions(opts = {})
      children.select {|child| child.type == :stepdefinition }
    end
    
    attr_accessor :step_transforms
    
    def step_transforms(opts = {})
      children.select {|child| child.type == :steptransform }
    end
    
  end

end


class StepDefinitionHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /^((When|Given|And|Then)\s*(\/[^\/]+\/).+)$/
  handles MATCH

  @@unique_name = 0
  
  def process

    predicateName = statement.tokens.to_s[MATCH,2]

    stepDefinition = statement.tokens.to_s[MATCH,3]
    
    
    #puts "Processing a #{predicateName}"
    #puts "with step definition: #{stepDefinition}"
	  @@unique_name = @@unique_name + 1
	
	  step_instance = StepDefinitionObject.new(namespace, "StepDefinition_#{@@unique_name}") {|o| o.source = statement.block.to_s ; o.value = stepDefinition ; o.predicate = predicateName}
	  
    obj = register step_instance 
    
    
    parse_block :owner => obj
  rescue YARD::Handlers::NamespaceMissingError
  end
end

class StepTransformHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /^Transform\s*(\/[^\/]+\/).+$/
  handles MATCH
  
  @@unique_name = 0
  
  def process
    transformDefinition = statement.tokens.to_s[MATCH,1]
  	log.debug "#process - transformDefinition = #{transformDefinition}"
  	@@unique_name = @@unique_name + 1

    obj = register StepTransformObject.new(namespace, "StepTransform_#{@@unique_name}") {|o| o.source = statement.block.to_s ; o.value = transformDefinition }
    
    parse_block :owner => obj
    
  rescue YARD::Handlers::NamespaceMissingError
  end
end