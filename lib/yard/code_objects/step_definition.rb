

module YARD::CodeObjects

  class StepDefinitionObject < Base
    include Cucumber::LocationHelper
    
    attr_reader :keyword, :value, :compare_value, :source 
    attr_accessor :constants, :steps
    
    def value=(value)
      @value = format_source(value)
      @constants = {}
      @steps = []
    end
    
    def compare_value
      base_value = value.gsub(/^\/|\/$/,'')
      @constants.each do |name,value|
        base_value.gsub!(/\#\{\s*#{name.to_s}\s*\}/,value.gsub(/^\/|\/$/,''))
      end
      base_value
    end
    
    def _value_constants(data=@value)
      #Hash[*data.scan(/\#\{([^\}]+)\}/).flatten.collect {|value| [value.strip,nil]}.flatten]
      data.scan(/\#\{([^\}]+)\}/).flatten.collect { |value| value.strip }
    end
    
    def constants=(value)
      value.each do |val| 
        @constants[val.name.to_s] = val if val.respond_to?(:name) && val.respond_to?(:value)
      end
    end    
    
  end
  
end