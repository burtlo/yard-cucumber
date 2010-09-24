

module YARD
  module Parser
    module Cucumber

      class Feature < YARD::CodeObjects::Base

        attr_accessor :value, :description, :scenarios, :background, :tags

        def initialize(namespace,name)
          super(namespace,name.strip)
          @description = []
          @background
          @scenarios = []
          @tags = []
        end

        def add_background(background)
          @background = Scenario.new(:root,"#{name}_background") {|s| s.value = background }
        end

        def add_scenario(scenario)
          @scenarios << Scenario.new(:root,"#{name}_scenario_#{@scenarios.count}") {|s| s.value = scenario }
          @scenarios.last
        end

      end

      class Scenario < YARD::CodeObjects::Base

        attr_accessor :value, :description, :steps, :tags

        def initialize(namespace,name)
          super(namespace,name.strip)
          @description = []
          @steps = []
          @tags = []
        end

        def add_step(step,linenumber)
          step = Step.new(:root,"#{name}_step_#{@steps.count}") {|s| s.value = step }
          step.add_file(@files.first.first,linenumber)
          @steps << step
        end

        def add_table(row,unique_name,linenumber)
          add_step(row,unique_name,linenumber)
        end

      end

      class Step < YARD::CodeObjects::Base
        attr_accessor :value, :definition
      end

      class FeatureParser < Base
        
        attr_accessor :features, :source
        
        def initialize(source, file = '(stdin)')
          @source = source
          log.debug "FeatureParser file #{file}"
          @file = file
          @namespaces
          @@unique_id = 0
          @features = []
          @tokens = { :tags => [], :line_number => 0 }
        end

        def parse
          tokenize
          self
        end

        def unique_id
          @@unique_id = @@unique_id + 1
        end

        def tokenize
          log.debug "Feature File Tokening"

          @tokens[:line_number] = 1

          @source.each do |line|
            log.debug "Tokenizing: #{line}"
            if line =~ /^\s*(@.+)/ then
              log.debug "New Tag"
              new_tags($1.split(' '))
            elsif line =~ /^\s*FEATURE\s*:(.+)$/i then
              log.debug "New Feature"
              @current_element = :feature
              new_feature($1)
            elsif line =~ /^\s*BACKGROUND\s*:(.*)$/i then
              log.debug "New Background"
              @current_element = :background
              new_scenario("Background")
            elsif line =~ /^\s*SCENARIO(?: OUTLINE)?\s*:(.+)$/i then
              log.debug "New Scenario"
              @current_element = :scenario
              new_scenario($1.strip)
            elsif line =~ /^\s*((?:GIVEN|WHEN|THEN|AND|BUT)\s*.+)$/i then
              log.debug "New Step"
              new_step($1)
            elsif line =~ /^\s*\|(.+)$/i then
              log.debug "New Table"
              new_table_row($1)
            else
              log.debug "New Description"
              new_description(line) unless line.strip == "" 
            end
            @tokens[:line_number] = @tokens[:line_number] + 1
          end

          @features

        end

        #
        # New tags will be added to old tags that exist
        # Tags are cleared at feature elements and scenario elements
        def new_tags(tags_array)
          @tokens[:tags] = [] unless @tokens[:tags]
          @tokens[:tags] = @tokens[:tags] + tags_array
        end

        #
        # New feature, only one in the file, any tags are added to the feature
        # tags are cleared, feature becomes the feature that scenarios are added to...
        #
        def new_feature(feature_title)
          @tokens[:feature] = Feature.new(:root,@file.gsub('.','_')) {|f| f.value = feature_title.strip }
          @features << @tokens[:feature]
          @tokens[:feature].add_file(@file,@tokens[:line_number])
          @tokens[:feature].tags = @tokens.delete(:tags)
        end


        #
        # On a new scenario, the previous scenario is popped and added to the feature
        # The new scenario gets any new tags that are hanging out and the current element moves to :scenario
        #
        def new_scenario(scenario_title)
          @tokens[@current_element] = @tokens[:feature].send("add_#{@current_element}",scenario_title) if @tokens[:feature]
          
          @tokens[@current_element].add_file(@file,@tokens[:line_number])
          @tokens[@current_element].tags = @tokens.delete(:tags)
        end

        def new_step(step_name)
          @tokens[@current_element].add_step(step_name,@tokens[:line_number]) if @tokens[@current_element]
        end

        #
        # This should likely not be a step and just another method that notes the order
        def new_table_row(table_row)
          @tokens[@current_element].add_table(table_row,"row_#{unique_id}",@tokens[:line_number]) if @tokens[@current_element]
        end

        def new_description(line)
          @tokens[@current_element].description << line.strip if (@current_element && @tokens[@current_element])
        end

        def enumerator
          @features
        end

      end
    end

    SourceParser.register_parser_type :feature, Cucumber::FeatureParser, 'feature'
  end
end



module YARD
  module Handlers
    module Cucumber
      
      class Base < Handlers::Base
        class << self
          include Parser::Cucumber
          def handles?(node)
            log.debug "Cucumber:Base handles? #{node}"
            handlers.any? do |a_handler|
              log.debug "A handler: #{a_handler}"
            end
          end
          include Parser::Cucumber
        end

      end

      class FeatureHandler < Base
        handles Parser::Cucumber::Feature

        def process 
          log.debug "FeatureHandler Online"

          feature_instance = statement


        rescue YARD::Handlers::NamespaceMissingError
        end
      end

    end

    Processor.register_handler_namespace :feature, Cucumber
  end 
end
