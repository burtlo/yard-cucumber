module YARD::CodeObjects
  class StepImplementationObject < Base
	attr_reader :value
	attr_reader :predicate
	
	def value=(value)
      @value = format_source(value)
    end
  end
  
  class StepDefinitionObject < Base

    attr_reader :value
	attr_reader :predicate
	
    def value=(value)
      @value = format_source(value)
    end
  end
  
  NamespaceObject.class_eval do

    attr_accessor :steps

    attr_reader :steps

    def steps(opts = {})
      children.select {|child| child.type == :stepdefinition }
    end
    
  end

end

module YARD::Serializers
  FileSystemSerializer.class_eval {
    def serialize(object, data)
      path = File.join(basepath, *serialized_path(object)[0,128])
      log.debug "Serializing to #{path}"
      File.open!(path, "wb") {|f| f.write data }
    end
  }
end


class StepDefinitionHandler < YARD::Handlers::Ruby::Legacy::Base
  #TODO: Find the trailing variables as well after the do
  MATCH = /^((When|Given|And|Then)\s*(\/[^\/]+\/).+)$/
  handles MATCH

  @@unique_name = 0
  
  def process

    stepDefinition = statement.tokens.to_s[MATCH,3]
    predicateName = statement.tokens.to_s[MATCH,2]
	#puts "Processing a #{predicateName}"
    #puts "with step definition: #{stepDefinition}"
	@@unique_name = @@unique_name + 1
	
    obj = register StepDefinitionObject.new(namespace, "#{predicateName}_#{@@unique_name}") {|o| o.source = statement.block.to_s ; o.value = stepDefinition ; o.predicate = predicateName}
    #obj = register StepDefinitionObject.new(namespace, stepDefinition) {|o| o.source = statement ; o.value = stepDefinition }
    
    parse_block :owner => obj
  rescue YARD::Handlers::NamespaceMissingError
    puts "rescue me"
  end
end

