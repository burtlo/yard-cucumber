

module YARD::CodeObjects::Cucumber

  class Step < Base
    
    attr_accessor :definition, :keyword, :scenario, :table, :text, :transforms, :value
    
    def initialize(namespace,name)
      super(namespace,name.to_s.strip)
      @definition = @description = @keyword = @table = @text = @value = nil
      @transforms = []
    end

    def has_table?
      !@table.nil?
    end

    def has_text?
      !@text.nil?
    end
    
    def transformed?
      !@transforms.empty?
    end

  end

end