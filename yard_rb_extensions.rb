
module YARD::CodeObjects


  #
  # StepDefinitions, as implemented in a ruby file
  #
  class StepDefinitionObject < Base

    attr_reader :value
    attr_reader :predicate

    # This is being used to hold the constants that are replaced. should likely just replace the constants
    attr_accessor :value_as_link
    attr_accessor :constants

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




end


class StepDefinitionHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /^((When|Given|And|Then)\s*(\/[^\/]+\/).+)$/
  handles MATCH

  @@unique_name = 0

  def process

    predicateName = statement.tokens.to_s[MATCH,2]
    stepDefinition = statement.tokens.to_s[MATCH,3]

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
    #log.debug "#process - transformDefinition = #{transformDefinition}"
    @@unique_name = @@unique_name + 1

    obj = register StepTransformObject.new(namespace, "StepTransform_#{@@unique_name}") {|o| o.source = statement.block.to_s ; o.value = transformDefinition }

    parse_block :owner => obj

  rescue YARD::Handlers::NamespaceMissingError
  end
end

