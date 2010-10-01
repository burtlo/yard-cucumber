

module YARD
  module Parser
    module Cucumber

      class Feature < YARD::CodeObjects::Base

        attr_accessor :value, :description, :scenarios, :background, :tags

        attr_accessor :filename

        def initialize(namespace,name)
          super(namespace,name.to_s.strip)
          @description = []
          @background
          @scenarios = []
          @tags = []
        end
      
        def add_background(background)
          @background = Scenario.new(:root,"#{name}_background") {|s| s.value = background ; s.feature = self  }
        end

        def add_scenario(scenario)
          @scenarios << Scenario.new(:root,"#{name}_scenario_#{@scenarios.count}") {|s| s.value = scenario ; s.feature = self }
          @scenarios.last
        end
        
        def tags=(tags)
          tags.each_with_index do |tag,index|
            @tags << Tag.new(:root,"#{name}_tag_#{tag[1..-1]}_#{index}") do |t| 
              t.value = tag
              t.add_file(@files.first[0],@files.first[1])
              t.feature = self
            end
          end
        end
        
        #TODO: this is likely a bad hack because I couldn't understand path
        def filename
          "#{self.name.to_s.gsub(/\//,'_')}.html"
        end

      end

      class Scenario < YARD::CodeObjects::Base

        attr_accessor :value, :description, :steps, :tags, :feature

        def initialize(namespace,name)
          super(namespace,name.to_s.strip)
          @description = []
          @steps = []
          @tags = []
        end

        def add_step(step,linenumber)
          step = Step.new(:root,"#{name}_step_#{@steps.count}") {|s| s.value = step ; s.scenario = self }
          step.add_file(@files.first.first,linenumber)
          @steps << step
        end

        def tags=(tags)
          tags.each_with_index do |tag,index|
            @tags << Tag.new(:root,"#{name}_tag_#{tag[1..-1]}_#{index}") do |t| 
              t.value = tag
              t.add_file(@files.first.first,@files.first.last)
              t.scenario = self
            end
          end
        end

        def add_table(row,unique_name,linenumber)
          add_step(row,unique_name,linenumber)
        end
        
        #TODO: this is likely a bad hack because I couldn't understand path
        def filename
          "#{self.name.to_s.gsub(/\//,'_')}.html"
        end
        

      end

      class Step < YARD::CodeObjects::Base
        attr_accessor :value, :definition, :scenario
        attr_reader :predicate, :line
        
        def predicate
          value.split(' ').first
        end
        
        def line
          value.split(' ',2).last
        end
      end
      
      class Tag < YARD::CodeObjects::Base
        
        attr_accessor :value, :feature, :scenario
        
        #TODO: this is likely a bad hack because I couldn't understand path
        def filename
          "#{self.name.to_s.gsub(/\//,'_')}.html"
        end
                
      end
      
      class TagUsage < YARD::CodeObjects::Base
        
        attr_accessor :tags
        
        def filename
          "#{self.name}.html"
        end
        
        def push(tag)
          @tags = [] unless @tags
          @tags << tag
        end
        
        alias_method :<<, :push
        
      end

      class FeatureParser < Base
        
        attr_accessor :features, :source
        
        def initialize(source, file = '(stdin)')
          @source = source
          @file = file
          @namespaces
          @features = []
          @tokens = { }
        end

        def parse
          @features = []
          @tokens = { :tags => [], :line_number => 1 }
          tokenize
          self
        end

        def tokenize
          
          @source.each do |line|
            if line =~ /^\s*(@.+)/ then
              new_tags($1.split(' '))
            elsif line =~ /^\s*FEATURE\s*:(.+)$/i then
              @current_element = :feature
              new_feature($1)
            elsif line =~ /^\s*BACKGROUND\s*:(.*)$/i then
              @current_element = :background
              new_scenario("Background")
            elsif line =~ /^\s*SCENARIO(?: OUTLINE)?\s*:(.+)$/i then
              @current_element = :scenario
              new_scenario($1.strip)
            elsif line =~ /^\s*((?:GIVEN|WHEN|THEN|AND|BUT)\s*.+)$/i then
              new_step($1)
            elsif line =~ /^\s*\|(.+)$/i then
              new_table_row($1)
            else
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
          @tokens[:feature].tags = @tokens.delete(:tags) || []
        end


        #
        # On a new scenario, the previous scenario is popped and added to the feature
        # The new scenario gets any new tags that are hanging out and the current element moves to :scenario
        #
        def new_scenario(scenario_title)
          @tokens[@current_element] = @tokens[:feature].send("add_#{@current_element}",scenario_title) if @tokens[:feature]
          @tokens[@current_element].add_file(@file,@tokens[:line_number])
          @tokens[@current_element].tags = @tokens.delete(:tags) || []
        end

        def new_step(step_name)
          if @current_element == :feature
            @tokens[@current_element].description << step_name.strip if @tokens[@current_element]
          else
            @tokens[@current_element].add_step(step_name,@tokens[:line_number]) if @tokens[@current_element]
          end
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
            log.debug "Cucumber::Base#handles? #{node.class}"
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
          log.debug "FeatureHandler Online #{statement}"
        rescue YARD::Handlers::NamespaceMissingError
        end
      end
    end

    Processor.register_handler_namespace :feature, Cucumber
  end 
end
