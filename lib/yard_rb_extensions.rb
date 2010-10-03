
module YARD::CodeObjects


  #
  # StepDefinitions, as implemented in a ruby file
  #
  class StepDefinitionObject < Base

    attr_reader :predicate, :value, :compare_value 
    attr_accessor :constants, :steps
    
    def value=(value)
      @value = format_source(value)
      @constants = {}
      @steps = []
    end
    
    def compare_value
      
      base_value = value.gsub(/^\/|\/$/,'')
      @constants.each do |name,constant|
        base_value.gsub!(/\#\{\s*#{name.to_s}\s*\}/,constant.value.gsub(/^\/|\/$/,''))
      end
      # TODO: When constants have constants it is important to replace them... this should be recursive and not just done twice
      @constants.each do |name,constant|
        base_value.gsub!(/\#\{\s*#{name.to_s}\s*\}/,constant.value.gsub(/^\/|\/$/,''))
      end
      base_value
    end
    
    def _value_constants(data=@value)
      #Hash[*data.scan(/\#\{([^\}]+)\}/).flatten.collect {|value| [value.strip,nil]}.flatten]
      data.scan(/\#\{([^\}]+)\}/).flatten.collect { |value| value.strip }
    end
    
    def constants=(value)
      value.each do |val| 
        @constants[val.name.to_s] = val if val.respond_to?(:name) && val.respond_to?(:value)
      end
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

