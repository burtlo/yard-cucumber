
module CucumberLocationHelper

  def line_number
    files.first.last
  end

  def file
    files.first.first
  end

  def location
    "#{files.first.first}:#{files.first.last}"
  end

end

module YARD::CodeObjects::Cucumber

  class Step < YARD::CodeObjects::Base
    include CucumberLocationHelper

    attr_accessor :definition, :keyword, :multiline_arg, :scenario, :value
    
    def initialize(namespace,name)
      super(namespace,name.to_s.strip)
      @definition = @description = @keyword = @multiline_arg = @value = nil
    end

    # TODO: This should be refactored to support a Table Object

    def has_table?
      @multiline_arg && !@multiline_arg.empty?
    end

    def has_string?
      @multiline_arg && !@multiline_arg.empty?
    end

  end

end