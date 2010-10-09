
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

    attr_accessor :definition, :keyword, :scenario, :table, :text, :value
    
    def initialize(namespace,name)
      super(namespace,name.to_s.strip)
      @definition = @description = @keyword = @table = @text = @value = nil
    end

    # TODO: This should be refactored to support a Table Object

    def has_table?
      !@table.nil?
    end

    def has_text?
      !@text.nil?
    end

  end

end