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

module YARD
  module CodeObjects 
    module Cucumber

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
  end
end