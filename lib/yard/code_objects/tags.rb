
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

  class Tag < YARD::CodeObjects::Base
    include CucumberLocationHelper

    attr_accessor :value, :feature, :scenario

    #TODO: this is likely a bad hack because I couldn't understand path
    def filename
      "#{self.name.to_s.gsub(/\//,'_')}.html"
    end

  end

  class TagUsage < YARD::CodeObjects::Base

    attr_reader :value

    attr_accessor :tags

    def filename
      "#{self.name}.html"
    end

    def push(tag)
      @tags = [] unless @tags
      @tags << tag

      if tag.scenario
        @scenario_count = 0 unless @scenario_count
        @scenario_count += 1 
      else
        @feature_count = 0 unless @feature_count
        @indirect_scenario_count = 0 unless @indirect_scenario_count
        @feature_count += 1
        @indirect_scenario_count += tag.feature.scenarios.length
      end

    end

    def scenario_count
      @scenario_count || 0
    end

    def feature_count
      @feature_count || 0
    end

    def indirect_scenario_count
      @indirect_scenario_count || 0
    end

    def total_scenario_count
      scenario_count + indirect_scenario_count
    end        

    alias_method :<<, :push

  end

end
