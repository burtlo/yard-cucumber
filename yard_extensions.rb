

module YARD
  module Parser
    module Cucumber
    
      class Feature < YARD::CodeObjects::Base
    
        attr_accessor :description, :scenarios, :tags
    
        def initialize(namespace,name)
          super(namespace,name.strip)
          @description = []
          @background
          @scenarios = []
          @tags = []
        end
        
        def add_background(background)
          @background = background 
        end
        
        def add_scenario(scenario)
          @scenarios << scenario
        end
    
      end
  
      class Scenario < YARD::CodeObjects::Base
    
        attr_accessor :description, :steps, :tags
    
        def initialize(namespace,name)
          super(namespace,name.strip)
          @description = []
          @steps = []
          @tags = []
        end
    
        def add_step(step,linenumber)
          step = Step.new(:root,step)
          step.add_file(@files[0][0],linenumber)
          @steps << step
        end
    
        def add_table(row,linenumber)
          add_step(row,linenumber)
        end
    
      end
  
      class Step < YARD::CodeObjects::Base
    
      end
  
      class FeatureParser < Base
        def initialize(source, file = '(stdin)')
          @source = source
          log.debug "FeatureParser file #{file}"
          @file = file
          @namespaces
      
          @tokens = { :tags => [], :line_number => 0 }
        end
    
        def parse
          log.debug "Feature File Parsed"
          tokenize
          self
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
            elsif line =~ /^\s*BACKGROUND\s*:(.+)$/i then
              log.debug "New Background"
              @current_element = :background
              new_scenario($1)
            elsif line =~ /^\s*SCENARIO(?: OUTLINE)?\s*:(.+)$/i then
              log.debug "New Scenario"
              @current_element = :scenario
              new_scenario($1)
            elsif line =~ /^\s*((?:GIVEN|WHEN|THEN|AND|BUT)\s*.+)$/i then
              log.debug "New Step"
              new_step($1)
            elsif line =~ /^\s*\|(.+)$/i then
              log.debug "New Table"
              new_table_row($1)
            else
              log.debug "New Description"
              new_description(line)
            end
            @tokens[:line_number] = @tokens[:line_number] + 1
          end
      
          @tokens[:feature]
      
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
          @tokens[:feature] = Feature.new(:root,feature_title)
          @tokens[:feature].add_file(@file,@tokens[:line_number])
          @tokens[:feature].tags = @tokens.delete(:tags)
        end
    
    
        #
        # On a new scenario, the previous scenario is popped and added to the feature
        # The new scenario gets any new tags that are hanging out and the current element moves to :scenario
        #
        def new_scenario(scenario_title)
          @tokens[:feature].send("add_#{@current_element}", @tokens.delete(:scenario)) if (@tokens[:feature] && @tokens[:scenario])
          @tokens[:scenario] = Scenario.new(:root,scenario_title)
          @tokens[:scenario].add_file(@file,@tokens[:line_number])
          @tokens[:scenario].tags = @tokens.delete(:tags)
        end
    
        def new_step(step_name)
          @tokens[:scenario].add_step(step_name,@tokens[:line_number]) if @tokens[:scenario]
        end
    
        #
        # This should likely not be a step and just another method that notes the order
        def new_table_row(table_row)
          @tokens[:scenario].add_table(table_row,@tokens[:line_number]) if @tokens[:scenario]
        end
    
        def new_description(line)
          @tokens[@current_element].description << line
        end
    
        def enumerator
          [ @tokens[:feature] ]
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


module YARD::CodeObjects
  
  #
  # Steps, as implemented in the Feature file
  #
  class StepImplementationObject < Base
    attr_reader :value
    attr_reader :predicate
	
    def value=(value)
      @value = format_source(value)
    end
  end
  
  #
  # StepDefinitions, as implemented in a ruby file
  #
  class StepDefinitionObject < Base

    attr_reader :value
    attr_reader :predicate
	  
    def constants
      value.scan(/\#\{([^\}]+)\}/).flatten
    end
	
    def value=(value)
      @value = format_source(value)
    end
  end

  #
  # Transforms
  #
  class StepTransformObject < Base
    attr_reader :value
    
    def value=(value)
      @value = format_source(value)
    end
  end
  
  class StepObject< Base
    
    attr_reader :value
    
    def value=(value)
      @value = format_source(value)
    end
    
  end
  
  #
  # Allow for steps and step definitions to be available on the NamespaceObject
  #  
  NamespaceObject.class_eval do

    attr_accessor :steps

    def steps(opts = {})
      children.select {|child| child.type == :step }
    end

    attr_accessor :step_definitions

    def step_definitions(opts = {})
      children.select {|child| child.type == :stepdefinition }
    end
    
    attr_accessor :step_transforms
    
    def step_transforms(opts = {})
      children.select {|child| child.type == :steptransform }
    end
    
  end

end


class StepDefinitionHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /^((When|Given|And|Then)\s*(\/[^\/]+\/).+)$/
  handles MATCH

  @@unique_name = 0
  
  def process

    predicateName = statement.tokens.to_s[MATCH,2]

    stepDefinition = statement.tokens.to_s[MATCH,3]
    
    
    #puts "Processing a #{predicateName}"
    #puts "with step definition: #{stepDefinition}"
    @@unique_name = @@unique_name + 1
	
    step_instance = StepDefinitionObject.new(namespace, "StepDefinition_#{@@unique_name}") {|o| o.source = statement.block.to_s ; o.value = stepDefinition ; o.predicate = predicateName}
	  
    obj = register step_instance 
    
    
    parse_block :owner => obj
  rescue YARD::Handlers::NamespaceMissingError
  end
end

class StepTransformHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /^Transform\s*(\/[^\/]+\/).+$/
  handles MATCH
  
  @@unique_name = 0
  
  def process
    transformDefinition = statement.tokens.to_s[MATCH,1]
    log.debug "#process - transformDefinition = #{transformDefinition}"
    @@unique_name = @@unique_name + 1

    obj = register StepTransformObject.new(namespace, "StepTransform_#{@@unique_name}") {|o| o.source = statement.block.to_s ; o.value = transformDefinition }
    
    parse_block :owner => obj
    
  rescue YARD::Handlers::NamespaceMissingError
  end
end

