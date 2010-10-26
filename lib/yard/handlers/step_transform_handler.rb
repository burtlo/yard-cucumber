
class StepTransformHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /^Transform\s*(\/.+\/)\s+do\s+\|.+\|\s*$/
  handles MATCH

  @@unique_name = 0
  
  def process
    transform = statement.tokens.to_s[MATCH,1]
    
    @@unique_name = @@unique_name + 1
    
    obj = register StepTransformObject.new(YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE, "transform_#{@@unique_name}") do |o| 
      o.source = "Transform #{transform} do #{statement.block.to_s}\nend"
      o.value = transform
      o.keyword = "Transform"
    end

    parse_block :owner => obj

  rescue YARD::Handlers::NamespaceMissingError
  end
end