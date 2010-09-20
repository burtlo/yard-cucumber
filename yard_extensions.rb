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

    def step_definitisions(opts = {})
      children.select {|child| child.type == :stepdefinitions }
    end
    
  end

end


class StepDefinitionHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /^((When|Given|And|Then)\s*(\/[^\/]+\/).+)$/
  handles MATCH

  @@unique_name = 0
  
  def process

    stepDefinition = statement.tokens.to_s[MATCH,3]
    predicateName = statement.tokens.to_s[MATCH,2]
	  #puts "Processing a #{predicateName}"
    #puts "with step definition: #{stepDefinition}"
	  @@unique_name = @@unique_name + 1
	
    obj = register StepDefinitionObject.new(namespace, "#{predicateName}_#{@@unique_name}") {|o| o.source = statement.block.to_s ; o.value = stepDefinition ; o.predicate = predicateName}
    #obj = register StepDefinitionObject.new(namespace, stepDefinition) {|o| o.source = statement ; o.value = stepDefinition }
    
    parse_block :owner => obj
  rescue YARD::Handlers::NamespaceMissingError
  end
end

