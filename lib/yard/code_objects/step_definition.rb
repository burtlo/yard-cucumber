

module YARD::CodeObjects

  class StepDefinitionObject < Base
    include Cucumber::LocationHelper
    
    attr_reader :constants, :keyword, :source, :value  
    attr_accessor :steps
    
    def value=(value)
      @value = format_source(value)
      @constants = {}
      @steps = []
      @compare_value = nil
    end
    
    def compare_value
      unless @compare_value
        @compare_value = value.gsub(/^\/|\/$/,'')
        @constants.each do |name,value|
          @compare_value.gsub!(/\#\{\s*#{name.to_s}\s*\}/,value.gsub(/^\/|\/$/,''))
        end
      end
      @compare_value
    end
    
    def _value_constants(data=@value)
      data.scan(/\#\{([^\}]+)\}/).flatten.collect { |value| value.strip }
    end
    
    def constants=(value)
      value.each do |val| 
        @constants[val.name.to_s] = val if val.respond_to?(:name) && val.respond_to?(:value)
      end
    end    
    
  end
  
end