
module YARD::CodeObjects
  
  NamespaceObject.class_eval do
    
    def remove_child(child)
      children.delete(child)
    end
    
    def add_child(child)
      children << child
    end
    
    
    attr_accessor :features

    def features(opts = {})
      children.select {|child| child.type == :feature }
    end

    attr_accessor :scenarios

    def scenarios(opts = {})
      children.select {|child| child.type == :scenario }
    end

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