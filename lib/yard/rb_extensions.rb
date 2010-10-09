
module YARD::CodeObjects


  #
  # StepDefinitions, as implemented in a ruby file
  #
  class StepDefinitionObject < Base
    
    attr_reader :keyword, :value, :compare_value, :source 
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
  
  class StepTransformersObject < Base
    
    attr_reader :source
    attr_accessor :definitions, :transforms
    
    def push(stepobject)
      if stepobject.is_a?(StepDefinitionObject)
        @definitions = [] unless @definitions
        @definitions << stepobject
      elsif stepobject.ia_a?(StepTransformObject)
        @transforms = [] unless @transforms
        @transforms << stepobject
      end
    end
    
    alias_method :<< , :push
    
    def filename
      "#{name}.html"
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

    keyword = statement.tokens.to_s[MATCH,2]
    step_definition = statement.tokens.to_s[MATCH,3]
    @@unique_name = @@unique_name + 1

    stepdef_instance = StepDefinitionObject.new(namespace, "StepDefinition_#{@@unique_name}") {|o| o.source = statement.block.to_s ; o.value = step_definition ; o.keyword = keyword}

    begin
      # Look for all constants within the step definitions
      stepdef_instance.constants = stepdef_instance._value_constants.each do |stepdef_constant| 
        owner.constants.each do |constant|
          if stepdef_constant.to_sym == constant.name
            log.info "Step definition #{stepdef_instance.value} linked to constant #{constant.name}"
            stepdef_instance.constants[stepdef_constant] = constant
            stepdef_instance.constants.merge(unpack_constants(constant))
          end
        end
      end
      
    rescue Exception => e
      log.error "Failed to link step definition to constants. This will make step definition to step linking impossible if constants are present.  #{e}"
    end
    

    obj = register stepdef_instance 


    parse_block :owner => obj
  rescue YARD::Handlers::NamespaceMissingError
  end
  
  
  def unpack_constants(constant)
    # if the constant value has a name of another constant then we want to return it as a hash with the constant name as the key,value
    inner_constants = {}

    constant.value.scan(/\#\{([^\}]+)\}/).flatten.collect { |value| value.strip }.each do |inner_constant|
      inner_constant_match = object.constants.find {|constant| constant.name == inner_constant }

      inner_constants.merge({ inner_constant => inner_constant_match }) if inner_constant_match
    end

    inner_constants
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

