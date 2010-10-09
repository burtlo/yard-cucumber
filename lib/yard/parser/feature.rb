module YARD::Parser::Cucumber

  class FeatureParser < YARD::Parser::Base

    def initialize(source, file = '(stdin)')

      @builder = Cucumber::Parser::CityBuilder.new(file)
      @tag_counts = {}
      @tag_formatter = Gherkin::Formatter::TagCountFormatter.new(@builder, @tag_counts)
      @parser = Gherkin::Parser::Parser.new(@tag_formatter, true, "root", false)

      @source = source
      @file = file

      @feature = nil
    end

    def parse
      log.info "FeatureParser"
      begin
        @parser.parse(@source, @file, 0)
        @feature = @builder.ast
        return nil if @feature.nil? # Nothing matched
        @feature.language = @parser.i18n_language
      rescue Gherkin::Lexer::LexingError, Gherkin::Parser::ParseError => e
        e.message.insert(0, "#{@file}: ")
        raise e
      end

      self
    end

    def tokenize
      
    end


    def enumerator
      [@feature]
    end

  end


  YARD::Parser::SourceParser.register_parser_type :feature, FeatureParser, 'feature'

end