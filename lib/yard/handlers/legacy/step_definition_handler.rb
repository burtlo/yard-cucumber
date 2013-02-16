class YARD::Handlers::Ruby::Legacy::StepDefinitionHandler < YARD::Handlers::Ruby::Legacy::Base
  STEP_DEFINITION_MATCH = /^((When|Given|And|Then)\s*(\/.+\/)\s+do(?:\s*\|.+\|)?\s*)$/ unless defined?(STEP_DEFINITION_MATCH)
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

    obj = register stepdef_instance
    parse_block :owner => obj

  rescue YARD::Handlers::NamespaceMissingError
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
