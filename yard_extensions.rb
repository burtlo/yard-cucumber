require 'rubygems'
require 'yard'

require File.dirname(__FILE__) + "/yard_rb_extensions.rb"
require File.dirname(__FILE__) + "/yard_cukes_extensions.rb"


module YARD::CodeObjects
  
  NamespaceObject.instance_eval do

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