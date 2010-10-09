
module Cucumber
  module Parser
    class CityBuilder
      include Gherkin::Rubify

      def initialize(file)
        @file = file
      end

      def ast
        @feature || @multiline_arg
      end

      def feature(feature)
        log.debug  "FEATURE: #{feature.name} #{feature.line} #{feature.keyword} #{feature.description}"
        
        @feature = YARD::CodeObjects::Cucumber::Feature.new(:root,@file.gsub('.','_')) do |f|
          f.comments = feature.comments.map{|comment| comment.value}.join("\n")
          f.description = feature.description
          f.add_file(@file,feature.line)
          f.keyword = feature.keyword
          f.value = feature.name
          f.tags = []
          
          feature.tags.map{|tag| tag.name}.each_with_index do |tag,index|
            f.tags << YARD::CodeObjects::Cucumber::Tag.new(:root,"#{f.name}_feature_tag_#{index}") do |t| 
              t.value = tag
              t.add_file(@file,feature.line)
              t.feature = f
            end
          end
          
        end
          
      end

      def background(background)
        log.debug "BACKGROUND #{background.keyword} #{background.name} #{background.line} #{background.description}"
        @background = YARD::CodeObjects::Cucumber::Scenario.new(:root,"#{@feature.name}_background") do |b|
          b.comments = background.comments.map{|comment| comment.value}.join("\n")
          b.description = background.description
          b.keyword = background.keyword
          b.value = background.name
          b.add_file(@file,background.line)
        end
        
        @feature.background = @background
        @background.feature = @feature
        @step_container = @background
      end

      def scenario(statement)
        log.debug "SCENARIO"
        scenario = YARD::CodeObjects::Cucumber::Scenario.new(:root,"#{@feature.name}_scenario_#{@feature.scenarios.length + 1}") do |s|
          s.comments = statement.comments.map{|comment| comment.value}.join("\n")
          s.description = statement.description
          s.add_file(@file,statement.line)
          s.keyword = statement.keyword
          s.value = statement.name
          
          statement.tags.map{|tag| tag.name}.each_with_index do |tag,index|
            s.tags << YARD::CodeObjects::Cucumber::Tag.new(:root,"#{s.name}_tag_#{index}") do |t| 
              t.value = tag
              t.add_file(@file,@feature.line)
              t.scenario = s
            end
          end
        end
        
        scenario.feature = @feature
        @feature.scenarios << scenario
        @step_container = scenario
      end

      def scenario_outline(statement)
        scenario(statement)
      end

      def examples(examples)
        log.debug "EXAMPLES"
        @step_container.examples << [
          examples.keyword,
          examples.name,
          examples.line,
          examples.comments.map{|comment| comment.value}.join("\n"),
          matrix(examples.rows) ]
      end

      def step(step)
        log.debug "STEP #{step.multiline_arg}"
        @table_owner = YARD::CodeObjects::Cucumber::Step.new(:root,"#{@feature.name}_#{step.line}") do |s|
          s.keyword = step.keyword
          s.value = step.name
          s.add_file(@file,step.line)
        end
                
        multiline_arg = rubify(step.multiline_arg)
        case(multiline_arg)
        when Gherkin::Formatter::Model::PyString
          @table_owner.text = multiline_arg.value
        when Array
          @table_owner.table = matrix(multiline_arg)
        end
        
        @table_owner.scenario = @step_container
        @step_container.steps << @table_owner
      end

      def eof
      end

      def syntax_error(state, event, legal_events, line)
        # raise "SYNTAX ERROR"
      end

      private

      def matrix(gherkin_table)
        gherkin_table.map do |gherkin_row|
          row = gherkin_row.cells
          class << row
            attr_accessor :line
          end
          row.line = gherkin_row.line
          row
        end
      end
    end
  end
end
