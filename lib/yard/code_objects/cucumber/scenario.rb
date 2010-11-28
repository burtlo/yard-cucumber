

module YARD::CodeObjects::Cucumber

  class Scenario < NamespaceObject
    
    attr_accessor :value, :comments, :keyword, :description, :steps, :tags, :feature
    
    def initialize(namespace,name)
      super(namespace,name.to_s.strip)
      @comments = @description = @keyword = @value = @feature = nil
      @steps = []
      @tags = []
    end
    
    def background?
      @keyword == "Background"
    end
    
    def outline?
      false
    end
    
  end

end