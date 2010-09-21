require 'rubygems'
require 'cucumber'

Cucumber.wants_to_quit = false
#TODO: probably needs to be in dry-run to make this work so that it will continue through the steps
# This is also likely a poor way to go out about getting the result that I need when it is something
# that may just use the Cucumber::Parser
module YARD
  module Handlers
  
  module Cucumber

    class FeatureVisitor
      
      attr_accessor :step_mother
      
      
      
      def visit_comment(comment) ; end
      def visit_tags(tags) ; end
      def visit_feature_name(keyword, indented_name) ; end
      def visit_background(background) ; end
      def visit_feature_element(element) 
        log.debug "FeatureVisitor in the element: #{element.class}"
        
        element.accept(self)
        
      end
      
      def visit_scenario_name(keyword, name, file_colon_line, source_ident) ; end
      
      
    end
    
    class Base < Handlers::Base
      class << self
        def handles?(node)
          
          log.debug "Cukes giving up? #{::Cucumber.wants_to_quit.class}"
          log.debug node.name
          log.debug node.accept(FeatureVisitor.new)
        end
      end
    end
    
    class FeatureHandler < Base
      
      def process 
        log.debug "FeatureHandler Online"
      rescue YARD::Handlers::NamespaceMissingError
      end
    end
    
  end
  
  Processor.register_handler_namespace :feature, Cucumber
end
end

module YARD::Parser
  class FeatureParser < Base
    def initialize(source, file = '(stdin)')
      @source = source
      log.debug "FeatureParser file #{file}"
      @file = file
      @namespaces
    end
    
    def parse
      log.debug "Feature File Parse"
      @features = Cucumber::StepMother.new.load_plain_text_features(@file)
      self
    end

    def tokenzie
      log.debug "Feature File Tokenize Not Implemented"
    end
    
    def enumerator
      log.debug "Feature File Enumerator"
      @features
    end
    
    end
  
  SourceParser.register_parser_type :feature, FeatureParser, 'feature'
  
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

