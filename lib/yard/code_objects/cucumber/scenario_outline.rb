

module YARD::CodeObjects::Cucumber

  class ScenarioOutline < NamespaceObject

    attr_accessor :value, :comments, :keyword, :description, :steps, :tags, :feature
    attr_accessor :scenarios, :examples

    def initialize(namespace,name)
      super(namespace,name.to_s.strip)
      @comments = @description = @value = @feature = nil
      @steps = []
      @tags = []
      @scenarios = []
      @examples = {}
    end

    def background?
      false
    end

    def outline?
      true
    end

    def example_keyword
      @examples[:keyword]
    end
    
    def example_headers
      return "Error - no example in a Scenario Outline - should it be a Scenario instead?" unless @examples[:rows]
      @examples[:rows].first
    end
    
    def example_data
      return "" unless @examples[:rows]
      @examples[:rows][1..-1]
    end

    def example_values_for_row(row)
      hash = {}

      example_headers.each_with_index do |header,index|
        hash[header] = example_data[row][index]
      end

      hash
    end
    
    def example_hash
      hash = {}
      
      @examples[:rows].each_with_index do |header,index|
        hash[header] = @examples[:rows].collect {|row| row[index] }
      end
      
      hash
    end
    
  end

end
