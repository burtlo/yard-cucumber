

module YARD::CodeObjects::Cucumber

  class Feature < NamespaceObject
    
    attr_accessor :background, :comments, :description, :keyword, :scenarios, :tags, :value, :total_scenarios

    def initialize(namespace,name)
      @comments = ""
      @scenarios = []
      @tags = []
      @total_scenarios = 0
      super(namespace,name.to_s.strip)
    end

  end

end
