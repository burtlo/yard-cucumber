

module YARD::CodeObjects::Cucumber

  class Feature < YARD::CodeObjects::Base
    include CucumberLocationHelper

    attr_accessor :background, :comments, :description, :keyword, :scenarios, :tags, :value

    def initialize(namespace,name)
      super(namespace,name.to_s.strip)
      @comments = []
      @scenarios = []
      @tags = []
    end

    #TODO: this is likely a bad hack because I couldn't understand path
    def filename
      "#{self.name.to_s.gsub(/\//,'_')}.html"
    end

  end

end