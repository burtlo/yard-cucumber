
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

  class Scenario < YARD::CodeObjects::Base
    include CucumberLocationHelper

    attr_accessor :value, :description, :steps, :tags, :feature, :examples
    
    def initialize(namespace,name)
      super(namespace,name.to_s.strip)
      @description = @value = @feature = nil
      @steps = []
      @tags = []
      @examples = []
    end

    #TODO: this is likely a bad hack because I couldn't understand path
    def filename
      "#{self.name.to_s.gsub(/\//,'_')}.html"
    end

  end

end