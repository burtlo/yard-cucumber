

class StepDefinitionHandler < YARD::Handlers::Ruby::Legacy::Base
  #TODO: This needs to become language independent.
  STEP_DEFINITION_MATCH = /^((When|Given|And|Then)\s*(\/.+\/)\s+do(?:\s*\|.+\|)?\s*)$/
  handles STEP_DEFINITION_MATCH

  @@unique_name = 0

  def process
    keyword = statement.tokens.to_s[STEP_DEFINITION_MATCH,2]
    step_definition = statement.tokens.to_s[STEP_DEFINITION_MATCH,3]

    @@unique_name = @@unique_name + 1

    stepdef_instance = StepDefinitionObject.new(YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE, "definition_#{@@unique_name}") do |o| 
      o.source = "#{keyword} #{step_definition} do #{statement.block.to_s =~ /^\s*\|.+/ ? '' : "\n  "}#{statement.block.to_s}\nend"
      o.value = step_definition
      o.keyword = keyword
    end
    
    # TODO: Currently I have not devised a good way to declare them or show them
    #find_steps_defined_in_block(statement.block)

    begin
      @constants = YARD::Registry.all(:constant)
      
      # Look for all constants within the step definitions
      stepdef_instance._value_constants.each do |stepdef_constant| 
        @constants.each do |constant|
          if stepdef_constant.to_sym == constant.name
            #log.debug "Constant #{constant.name} was found in the step definition #{stepdef_instance.value}, attempting to replace that value"
            returned_constant = unpack_constants(constant.value)
            #log.debug "CONSTANT: #{constant.name}\nFINAL: #{returned_constant}"
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
      inner_constant_match = @constants.find {|constant| constant.name.to_s == inner_constant }
      if inner_constant_match
        constant_value.gsub!(/\#\{#{inner_constant}\}/,unpack_constants(inner_constant_match.value))
      end
    end
    
    constant_value.gsub!(/^('|"|\/)|('|"|\/)$/,'')
    constant_value
  end
  
  #
  # Step Definitions can contain defined steps within them.  While it is likely that they could not
  # very easily be parsed because of variables that are only calculated at runtime, it would be nice
  # to at least list those in use within a step definition and if you can find a match, go ahead and
  # make it
  #
  def find_steps_defined_in_block(block)
    #log.debug "#{block} #{block.class}"
    block.each_with_index do |token,index|
      #log.debug "Token #{token.class} #{token.text}"
        if token.is_a?(YARD::Parser::Ruby::Legacy::RubyToken::TkCONSTANT)  && 
          token.text =~ /^(given|when|then|and)$/i &&
          block[index + 2].is_a?(YARD::Parser::Ruby::Legacy::RubyToken::TkSTRING)
          log.debug "Step found in Step Definition: #{block[index + 2].text} "
        end
          
    end
    
  end
  
end
