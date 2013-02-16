
class YARD::Handlers::Ruby::StepTransformHandler < YARD::Handlers::Ruby::Base
  handles method_call(:Transform)

  process do

    instance = YARD::CodeObjects::StepTransformObject.new(step_transform_namespace,step_transformer_name) do |o|
      o.source = statement.source
      o.comments = statement.comments
      o.keyword = statement[0].source
      o.value = statement[1].source
    end

    obj = register instance
    parse_block(statement[2],:owner => obj)

  end

  def step_transform_namespace
    YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE
  end

  def step_transformer_name
    "step_transform#{self.class.generate_unique_id}"
  end

  def self.generate_unique_id
    @step_transformer_count = @step_transformer_count.to_i + 1
  end

end