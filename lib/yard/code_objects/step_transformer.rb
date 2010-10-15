
module YARD::CodeObjects

  class StepTransformObject < Base
    include Cucumber::LocationHelper
    
    attr_reader :value

    def value=(value)
      @value = format_source(value)
    end
  end
  
end