
module Cucumber
  module Parser
    class CityBuilder
      include Gherkin::Rubify

      def initialize(file)
        @namespace = YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE
        find_or_create_namespace(file)
        @file = file
      end

      def ast
        @feature || @multiline_arg
      end

      def find_or_create_namespace(file)
        # TODO: The directory that is added should have the full path
        file.split('/')[0..-2].each do |directory|
          @namespace = @namespace.children.find {|child| child.name == directory } ||
            YARD::CodeObjects::Cucumber::FeatureDirectory.new(@namespace,directory) {|dir| dir.add_file(directory)}
        end
      end

      def find_or_create_tag(tag_name,parent)
        #log.debug "Processing tag #{tag_name}"
        tag_code_object = YARD::Registry.all(:tag).find {|tag| tag.value == tag_name } || 
          YARD::CodeObjects::Cucumber::Tag.new(YARD::CodeObjects::Cucumber::CUCUMBER_TAG_NAMESPACE,tag_name.gsub('@','')) {|t| t.owners = [] ; t.value = tag_name }

        tag_code_object.add_file(@file,parent.line)

        parent.tags << tag_code_object unless parent.tags.find {|tag| tag == tag_code_object }
        tag_code_object.owners << parent unless tag_code_object.owners.find {|owner| owner == parent}
      end

      def feature(feature)
        #log.debug  "FEATURE: #{feature.name} #{feature.line} #{feature.keyword} #{feature.description}"
        @feature = YARD::CodeObjects::Cucumber::Feature.new(@namespace,File.basename(@file.gsub('.feature','').gsub('.','_'))) do |f|
          f.comments = feature.comments.map{|comment| comment.value}.join("\n")
          f.description = feature.description
          f.add_file(@file,feature.line)
          f.keyword = feature.keyword
          f.value = feature.name
          f.tags = []

          feature.tags.each {|feature_tag| find_or_create_tag(feature_tag.name,f) }
        end
      end

      def background(background)
        #log.debug "BACKGROUND #{background.keyword} #{background.name} #{background.line} #{background.description}"
        @background = YARD::CodeObjects::Cucumber::Scenario.new(@feature,"background") do |b|
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
        #log.debug "SCENARIO"
        scenario = YARD::CodeObjects::Cucumber::Scenario.new(@feature,"scenario_#{@feature.scenarios.length + 1}") do |s|
          s.comments = statement.comments.map{|comment| comment.value}.join("\n")
          s.description = statement.description
          s.add_file(@file,statement.line)
          s.keyword = statement.keyword
          s.value = statement.name

          statement.tags.each {|scenario_tag| find_or_create_tag(scenario_tag.name,s) }
        end

        scenario.feature = @feature
        @feature.scenarios << scenario
        @step_container = scenario
      end

      def scenario_outline(statement)
        #log.debug "SCENARIO OUTLINE"

        outline = YARD::CodeObjects::Cucumber::ScenarioOutline.new(@feature,"scenario_#{@feature.scenarios.length + 1}") do |s|
          s.comments = statement.comments.map{|comment| comment.value}.join("\n")
          s.description = statement.description
          s.add_file(@file,statement.line)
          s.keyword = statement.keyword
          s.value = statement.name

          statement.tags.each {|scenario_tag| find_or_create_tag(scenario_tag.name,s) }
        end

        outline.feature = @feature
        @feature.scenarios << outline
        @step_container = outline
      end

      def examples(examples)
        #log.debug "EXAMPLES #{examples.name}"

        @step_container.examples = { :keyword => examples.keyword,
          :name => examples.name,
          :line => examples.line,
          :comments => examples.comments.map{|comment| comment.value}.join("\n"),
          :rows => matrix(examples.rows) }

        # For each example generate a scenario and steps
        
        @step_container.example_data.length.times do |row_index|

          scenario = YARD::CodeObjects::Cucumber::Scenario.new(@step_container,"example_#{@step_container.scenarios.length + 1}") do |s|
            s.comments = @step_container.comments
            s.description = @step_container.description
            s.add_file(@file,@step_container.line_number)
            s.keyword = @step_container.keyword
            s.value = "#{@step_container.value} (#{@step_container.scenarios.length + 1})"

            #TODO: Should scenario instances have their own tag instances?
          end

          @step_container.steps.each do |step|
            step_instance = YARD::CodeObjects::Cucumber::Step.new(scenario,step.line_number) do |s|
              s.keyword = step.keyword.dup
              s.value = step.value.dup
              s.add_file(@file,step.line_number)

              s.text = step.text.dup if step.has_text?
              s.table = clone_table(step.table) if step.has_table?
            end

            @step_container.example_values_for_row(row_index).each do |key,text|
              step_instance.value.gsub!("<#{key}>",text)
              step_instance.text.gsub!("<#{key}>",text) if step_instance.has_text?
              step_instance.table[1..-1].each{|row| row.each{|col| col.gsub!("<#{key}>",text)}} if step_instance.has_table?
            end

            step_instance.scenario = scenario
            scenario.steps << step_instance
          end

          # Scenario instances of an outline link to the feature but are not linked from the feature
          # @feature.scenarios << scenario

          scenario.feature = @feature
          @step_container.scenarios << scenario
          
        end
        
      end

      def step(step)
        #log.debug "STEP #{step.multiline_arg}"
        @table_owner = YARD::CodeObjects::Cucumber::Step.new(@step_container,"#{step.line}") do |s|
          s.keyword = step.keyword
          s.value = step.name
          s.add_file(@file,step.line)
        end

        multiline_arg = rubify(step.multiline_arg)
        
        case(multiline_arg)
        when Gherkin::Formatter::Model::PyString
          @table_owner.text = multiline_arg.value
        when Array
          #log.info "Matrix: #{matrix(multiline_arg).collect{|row| row.collect{|cell| cell.class } }.flatten.join("\n")}"
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

      def clone_table(base)
        base.map {|row| row.map {|cell| cell.dup }}
      end
    end
  end
end
