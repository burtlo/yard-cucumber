

module YARD::CodeObjects::Cucumber

  class Step < Base
    
    attr_accessor :definition, :examples, :keyword, :scenario, :table, :text, :transforms, :value
    
    def initialize(namespace,name)
      super(namespace,name.to_s.strip)
      @definition = @description = @keyword = @table = @text = @value = nil
      @examples = {}
      @transforms = []
    end
    
    def has_table?
      !@table.nil?
    end

    def has_text?
      !@text.nil?
    end
    
    def definition=(stepdef)
      @definition = stepdef
      stepdef.steps << self
    end
    
    def transformed?
      !@transforms.empty?
    end

  end

end