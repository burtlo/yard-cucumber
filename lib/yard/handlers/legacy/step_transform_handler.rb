class YARD::Handlers::Ruby::Legacy::StepTransformHandler < YARD::Handlers::Ruby::Legacy::Base
  STEP_TRANSFORM_MATCH = /^(Transform\s*(\/.+\/)\s+do(?:\s*\|.+\|)?\s*)$/ unless defined?(STEP_TRANSFORM_MATCH)
  handles STEP_TRANSFORM_MATCH

  @@unique_name = 0
  
  def process
    transform = statement.tokens.to_s[STEP_TRANSFORM_MATCH,2]
    @@unique_name = @@unique_name + 1
    
    instance = StepTransformObject.new(YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE, "transform_#{@@unique_name}") do |o| 
      o.source = "Transform #{transform} do #{statement.block.to_s}\nend"
      o.value = transform
      o.keyword = "Transform"
    end
  
    obj = register instance
    parse_block :owner => obj
    
  rescue YARD::Handlers::NamespaceMissingError
  end
  
end

