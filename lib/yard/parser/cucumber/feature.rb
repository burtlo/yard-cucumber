module YARD::Parser::Cucumber

  class FeatureParser < YARD::Parser::Base
    
    #
    # Each found feature found is creates a new FeatureParser
    # 
    # This logic was copied from the logic found in Cucumber to create the builder
    # and then set up the formatter and parser. The difference is really the
    # custom Cucumber::Parser::CityBuilder that is being used to parse the elements
    # of the feature into YARD::CodeObjects.
    # 
    # @param [<String>] source containing the string conents of the feauture file
    # @param [<String>] file the filename that contains the source
    # 
    def initialize(source, file = '(stdin)')

      @builder = Cucumber::Parser::CityBuilder.new(file)
      @tag_counts = {}
      @tag_formatter = Gherkin::Formatter::TagCountFormatter.new(@builder, @tag_counts)
      @parser = Gherkin::Parser::Parser.new(@tag_formatter, true, "root", false)

      @source = source
      @file = file

      @feature = nil
    end

    #
    # When parse is called, the gherkin parser is executed and all the feature
    # elements that are found are sent to the various methods in the 
    # Cucumber::Parser::CityBuilder. The result of which is the feature element
    # that contains all the scenarios, steps, etc. associated with that feature.
    # 
    # @see Cucumber::Parser::CityBuilder
    def parse
      begin
        @parser.parse(@source, @file, 0)
        @feature = @builder.ast
        return nil if @feature.nil? # Nothing matched
        
        # The parser used the following keywords when parsing the feature
        # @feature.language = @parser.i18n_language.get_code_keywords.map {|word| word }
        
      rescue Gherkin::Lexer::LexingError, Gherkin::Parser::ParseError => e
        e.message.insert(0, "#{@file}: ")
        raise e
      end
      
      self
    end

    #
    # This is not used as all the work is done in the parse method
    # 
    def tokenize
      
    end

    # 
    # The only enumeration that can be done here is returning the feature itself
    # 
    def enumerator
      [@feature]
    end

  end

  # 
  # Register all feature files (.feature) to be processed with the above FeatureParser
  YARD::Parser::SourceParser.register_parser_type :feature, FeatureParser, 'feature'

end