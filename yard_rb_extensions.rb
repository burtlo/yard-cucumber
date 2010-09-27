
module YARD::CodeObjects


  #
  # StepDefinitions, as implemented in a ruby file
  #
  class StepDefinitionObject < Base

    attr_reader :predicate, :value, :compare_value
    attr_accessor :constants

    def value=(value)
      @value = format_source(value)
    end
    
    def compare_value
      
      base_value = value
      self.constants.each do |constant|
        #TODO: This replacement should only be done when it is seen in an escape
        base_value.gsub!(/\#\{\s*#{constant.name.to_s}\s*\}/,constant.value[1..-2])
      end
      base_value
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

