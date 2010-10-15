

module YARD::CodeObjects::Cucumber

  class Scenario < NamespaceObject
    
    attr_accessor :value, :description, :steps, :tags, :feature, :examples
    
    def initialize(namespace,name)
      super(namespace,name.to_s.strip)
      @description = @value = @feature = nil
      @steps = []
      @tags = []
      @examples = []
    end
    
    def background?
      @keyword == "Background"
    end
    
    def outline?
      @examples && !examples.empty?
    end
    
    def example_keyword
      @examples.first.first.to_s.strip
    end
    
    def example_headers
      @examples.first.find {|example| example.is_a?(Array) }.first
    end
    
    def example_data
      @examples.first.find {|example| example.is_a?(Array) }[1..-1]
    end
    
  end

end