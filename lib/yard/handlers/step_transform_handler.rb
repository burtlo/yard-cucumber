

class StepTransformHandler < YARD::Handlers::Ruby::Legacy::Base
  STEP_TRANSFORM_MATCH = /^(Transform\s*(\/.+\/)\s+do(?:\s*\|.+\|)?\s*)$/
  handles STEP_TRANSFORM_MATCH

  @@unique_name = 0
  
  def process
    transform = statement.tokens.to_s[STEP_TRANSFORM_MATCH,2]
    @@unique_name = @@unique_name + 1
    
    instance = StepTransformObject.new(YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE, "transform_#{@@unique_name}") do |o| 
      o.source = "Transform #{transform} do #{statement.block.to_s}\nend"
      o.value = transform
      o.keyword = "Transform"
    end
    
    log.debug "Step Tranform: #{instance}"

    begin
      @constants = YARD::Registry.all(:constant)
      
      # Look for all constants within the step transforms
      instance._value_constants.each do |instance_constants| 
        @constants.each do |constant|
          if instance_constants.to_sym == constant.name
            log.debug "Constant #{constant.name} was found in the step definition #{stepdef_instance.value}, attempting to replace that value"
            returned_constant = unpack_constants(constant.value)
            log.debug "CONSTANT: #{constant.name}\nFINAL: #{returned_constant}"
            obj.constants[constant.name] = unpack_constants(constant.value)
          end
        end
      end

    rescue Exception => e
      log.error "Failed to link step transform to constants. This will make step transform to step linking impossible if constants are present.  #{e}"
    end

    obj = register instance
    parse_block :owner => obj
    
  rescue YARD::Handlers::NamespaceMissingError
  end
  
  
  def unpack_constants(constant_value)
    constant_value.scan(/\#\{([^\}]+)\}/).flatten.collect { |value| value.strip }.each do |inner_constant|
      inner_constant_match = @constants.find {|constant| constant.name.to_s == inner_constant }
      if inner_constant_match
        constant_value.gsub!(/\#\{#{inner_constant}\}/,unpack_constants(inner_constant_match.value))
      end
    end

    constant_value.gsub!(/^('|"|\/)|('|"|\/)$/,'')
    constant_value
  end
  
end

