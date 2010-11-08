
module YARD::CodeObjects

  class StepTransformerObject < Base

    include Cucumber::LocationHelper

    attr_reader :constants, :keyword, :source, :value
    attr_accessor :steps

    ESCAPE_PATTERN = /#\{\s*(\w+)\s*\}/

    def value=(value)
      @value = format_source(value)

      until (nested = constants_from_value).empty?
        nested.each {|n| @value.gsub!(value_regex(n),find_value_for_constant(n)) }
      end
      
      @steps = []
    end

    def regex
      @regex ||= /#{strip_regex_from(@value)}/
    end

    def constants_from_value(data=@value)
      data.scan(ESCAPE_PATTERN).flatten.collect { |value| value.strip }
    end

    protected

    def find_value_for_constant(name)
      constant = YARD::Registry.all(:constant).find{|c| c.name == name.to_sym }
      log.warn "StepTransformer#find_value_for_constant : Could not find the CONSTANT #{name} using an empty string for value." unless constant
      constant ? strip_regex_from(constant.value) : ""
    end
  
    def value_regex(value)
      /#\{\s*#{value}\s*\}/
    end

    def strip_regex_from(value)
      value.gsub(/^\/|\/$/,'')
    end


  end

end