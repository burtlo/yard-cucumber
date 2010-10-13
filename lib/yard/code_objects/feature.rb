

module YARD::CodeObjects::Cucumber

  class Feature < Base
    
    attr_accessor :background, :comments, :description, :keyword, :scenarios, :tags, :value

    def initialize(namespace,name)
      super(namespace,name.to_s.strip)
      @comments = []
      @scenarios = []
      @tags = []
    end

  end

end