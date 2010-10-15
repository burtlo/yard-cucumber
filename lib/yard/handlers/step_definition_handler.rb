

class StepDefinitionHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /^((When|Given|And|Then)\s*(\/[^\/]+\/).+)$/
  handles MATCH

  @@unique_name = 0

  def process
    keyword = statement.tokens.to_s[MATCH,2]
    step_definition = statement.tokens.to_s[MATCH,3]

    @@unique_name = @@unique_name + 1

    stepdef_instance = StepDefinitionObject.new(YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE, "definition_#{@@unique_name}") do |o| 
      o.source = "#{keyword} #{step_definition} do #{statement.block.to_s =~ /^\s*\|.+/ ? '' : "\n  "}#{statement.block.to_s}\nend"
      o.value = step_definition
      o.keyword = keyword
    end

    begin
      # Look for all constants within the step definitions
      stepdef_instance.constants = stepdef_instance._value_constants.each do |stepdef_constant| 
        owner.constants.each do |constant|
          if stepdef_constant.to_sym == constant.name
            #log.debug "Replacing #{constant.name} with its value in the step definition #{stepdef_instance.value}"
            stepdef_instance.constants[constant.name] = unpack_constants(constant.value)
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
  
  
  def unpack_constants(constant_value)
    constant_value.scan(/\#\{([^\}]+)\}/).flatten.collect { |value| value.strip }.each do |inner_constant|
      inner_constant_match = owner.constants.find {|constant| constant.name.to_s == inner_constant }
      if inner_constant_match
        constant_value.gsub!(/\#\{#{inner_constant}\}/,unpack_constants(inner_constant_match.value))
      end
    end
    
    constant_value.gsub!(/^('|"|\/)|('|"|\/)$/,'')
    constant_value
  end
  
end
