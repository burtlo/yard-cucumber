
module Cucumber
  module Parser
    class CityBuilder
      include Gherkin::Rubify
      
      #
      # The Gherkin Parser is going to call the various methods within this
      # class as it finds items. This is similar to how Cucumber generates
      # it's Abstract Syntax Tree (AST). Here instead this generates the
      # various YARD::CodeObjects defined within this template.
      # 
      # A namespace is specified and that is the place in the YARD namespacing
      # where all cucumber features generated will reside. The namespace specified
      # is the root namespaces.
      # 
      # @param [String] file the name of the file which the content belongs
      # 
      def initialize(file)
        @namespace = YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE
        find_or_create_namespace(file)
        @file = file
      end

      # Return the feature that has been defined. This method is the final
      # method that is called when all the work is done. It is called by
      # the feature parser to return the complete Feature object that was created
      # 
      # @return [YARD::CodeObject::Cucumber::Feature] the completed feature
      # 
      # @see YARD::Parser::Cucumber::FeatureParser
      def ast
        @feature
      end
      
      #
      # Feature that are found in sub-directories are considered, in the way
      # that I chose to implement it, in another namespace. This is because
      # when you execute a cucumber test run on a directory any sub-directories
      # of features will be executed with that directory so the file is split
      # and then namespaces are generated if they have not already have been.
      # 
      # The other duty that this does is look for a README.md file within the
      # specified directory of the file and loads it as the description for the
      # namespace. This is useful if you want to give a particular directory
      # some flavor or text to describe what is going on.
      # 
      def find_or_create_namespace(file)
        @namespace = YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE
        
        File.dirname(file).split('/').each do |directory|
          @namespace = @namespace.children.find {|child| child.is_a?(YARD::CodeObjects::Cucumber::FeatureDirectory) && child.name.to_s == directory } ||
            @namespace = YARD::CodeObjects::Cucumber::FeatureDirectory.new(@namespace,directory) {|dir| dir.add_file(directory)}
        end

        if @namespace.description == "" && File.exists?("#{File.dirname(file)}/README.md")
          @namespace.description = File.read("#{File.dirname(file)}/README.md")
        end
      end
      
      #
      # Find the tag if it exists within the YARD Registry, if it doesn' t then
      # create it. 
      # 
      # We note that the tag was used in this file at the current line.
      # 
      # Then we add the tag to the current scenario or feature. We also add the
      # feature or scenario to the tag.
      # 
      # @param [String] tag_name the name of the tag
      # @param [parent] parent the scenario or feature that is going to adopt
      #     this tag.
      # 
      def find_or_create_tag(tag_name,parent)
        #log.debug "Processing tag #{tag_name}"
        tag_code_object = YARD::Registry.all(:tag).find {|tag| tag.value == tag_name } ||
          YARD::CodeObjects::Cucumber::Tag.new(YARD::CodeObjects::Cucumber::CUCUMBER_TAG_NAMESPACE,tag_name.gsub('@','')) {|t| t.owners = [] ; t.value = tag_name }

        tag_code_object.add_file(@file,parent.line)

        parent.tags << tag_code_object unless parent.tags.find {|tag| tag == tag_code_object }
        tag_code_object.owners << parent unless tag_code_object.owners.find {|owner| owner == parent}
      end
      
      #
      # Each feature found will call this method, generating the feature object.
      # This is once, as the gherking parser does not like multiple feature per
      # file.
      # 
      def feature(feature)
        #log.debug "FEATURE"
        
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
      
      #
      # Called when a background has been found
      # 
      # @see #scenario
      def background(background)
        #log.debug "BACKGROUND"
        
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
      
      #
      # Called when a scenario has been found
      #   - create a scenario
      #   - assign the scenario to the feature
      #   - assign the feature to the scenario
      #   - find or create tags associated with the scenario
      # 
      # The scenario is set as the @step_container, which means that any steps
      # found before another scenario is defined belong to this scenario
      # 
      # @param [Scenario] statement is a scenario object returned from Gherkin
      # @see #find_or_create_tag
      # 
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
      
      #
      # Called when a scenario outline is found. Very similar to a scenario,
      # the ScenarioOutline is still a distinct object as it can contain
      # multiple different example groups that can contain different values.
      # 
      # @see #scenario
      # 
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

      #
      # Examples for a scenario outline are called here. This section differs
      # from the Cucumber parser because here each of the examples are exploded
      # out here as individual scenarios and step definitions. This is so that
      # later we can ensure that we have all the variations of the scenario
      # outline defined to be displayed. 
      # 
      def examples(examples)
        #log.debug "EXAMPLES"

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
              text ||= "" #handle empty cells in the example table
              step_instance.value.gsub!("<#{key}>",text)
              step_instance.text.gsub!("<#{key}>",text) if step_instance.has_text?
              step_instance.table.each{|row| row.each{|col| col.gsub!("<#{key}>",text)}} if step_instance.has_table?
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

      # 
      # Called when a step is found. The step is refered to a table owner, though
      # not all steps have a table or multliline arguments associated with them.
      # 
      # If a multiline string is present with the step it is included as the text
      # of the step. If the step has a table it is added to the step using the
      # same method used by the Cucumber Gherkin model.
      # 
      def step(step)
        #log.debug "STEP"

        @table_owner = YARD::CodeObjects::Cucumber::Step.new(@step_container,"#{step.line}") do |s|
          s.keyword = step.keyword
          s.value = step.name
          s.add_file(@file,step.line)
        end

        @table_owner.comments = step.comments.map{|comment| comment.value}.join("\n")

        multiline_arg = rubify(step.multiline_arg)
        
        case(multiline_arg)
        when gherkin_multiline_string_class
          @table_owner.text = multiline_arg.value
        when Array
          #log.info "Matrix: #{matrix(multiline_arg).collect{|row| row.collect{|cell| cell.class } }.flatten.join("\n")}"
          @table_owner.table = matrix(multiline_arg)
        end
        
        @table_owner.scenario = @step_container
        @step_container.steps << @table_owner
      end

      # Defined in the cucumber version so left here. No events for the end-of-file
      def eof
      end

      # When a syntax error were to occurr. This parser is not interested in errors
      def syntax_error(state, event, legal_events, line)
        # raise "SYNTAX ERROR"
      end

      private
      def matrix(gherkin_table)
        gherkin_table.map {|gherkin_row| gherkin_row.cells }
      end
      
      #
      # This helper method is used to deteremine what class is the current
      # Gherkin class.
      # 
      # @return [Class] the class that is the current supported Gherkin Model
      #     for multiline strings. Prior to Gherkin 2.4.0 this was the PyString
      #     class. As of Gherkin 2.4.0 it is the DocString class.
      def gherkin_multiline_string_class
        if defined?(Gherkin::Formatter::Model::PyString)
          Gherkin::Formatter::Model::PyString
        elsif defined?(Gherkin::Formatter::Model::DocString)
          Gherkin::Formatter::Model::DocString
        else
          raise "Unable to find a suitable class in the Gherkin Library to parse the multiline step data."
        end
      end

      def clone_table(base)
        base.map {|row| row.map {|cell| cell.dup }}
      end
      
    end
  end
end
