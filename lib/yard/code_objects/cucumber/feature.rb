module YARD::CodeObjects::Cucumber

  class Feature < NamespaceObject

    attr_accessor :background, :comments, :description, :keyword, :scenarios, :tags, :value

    def initialize(namespace, name)
      @comments = ""
      @scenarios = []
      @tags = []
      super(namespace, name.to_s.strip)
    end
  end
end