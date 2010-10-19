
module YARD::CodeObjects

  class StepTransformObject < Base
    include Cucumber::LocationHelper
    
    attr_reader :value

    def value=(value)
      @value = format_source(value)
      @steps = []
    end
    
    def compare_value
      value.gsub(/^\/|\/$/,'')
    end
    
  end
  
end