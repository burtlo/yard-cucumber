
class YARD::Handlers::Ruby::StepTransformHandler < YARD::Handlers::Ruby::Base
  handles method_call(:Transform)
  
  @@unique_name = 0

  process do
    @@unique_name += 1
    
    instance = YARD::CodeObjects::StepTransformObject.new(YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE,"step_transform#{@@unique_name}") do |o| 
      o.source = statement.source
      o.comments = statement.comments
      o.keyword = statement[0].source
      o.value = statement[1].source
    end

    obj = register instance
    parse_block(statement[2],:owner => obj)

  end

end

