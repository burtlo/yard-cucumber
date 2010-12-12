
class YARD::Handlers::Ruby::StepDefinitionHandler < YARD::Handlers::Ruby::Base
  handles method_call(:When),method_call(:Given),method_call(:And),method_call(:Then)
  
  @@unique_name = 0
  
  process do
    @@unique_name += 1

    instance = StepDefinitionObject.new(YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE,"step_definition#{@@unique_name}") do |o| 
      o.source = statement.source
      o.comments = statement.comments
      o.keyword = statement[0].source
      o.value = statement[1].source
    end

    obj = register instance
    parse_block(statement[2],:owner => obj)
    
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
