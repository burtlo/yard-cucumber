
class YARD::Handlers::Ruby::StepTransformHandler < YARD::Handlers::Ruby::Base
  handles method_call(:Transform)
  handles method_call(:ParameterType)

  process do

    nextStatement = nil
    instance = YARD::CodeObjects::StepTransformObject.new(step_transform_namespace,step_transformer_name) do |o|
      o.source = statement.source
      o.comments = statement.comments
      o.keyword = statement[0].source
      if (o.keyword == 'Transform')
        o.value = statement[1].source.gsub(/(^\(?\/|\/\)?$)/, '').gsub(/(^\^|\$$)/, '')
        nextStatement = statement[2]
      elsif (o.keyword == 'ParameterType')
        o.value = find(statement, :label, 'regexp:').parent.children[1].source.gsub(/(^\(?\/|\/\)?$)/, '').gsub(/(^\^|\$$)/, '')
        nextStatement = find(statement, :label, 'transformer:').parent.children[1]
      end
    end

    obj = register instance
    parse_block(nextStatement,:owner => obj)

  end

  def step_transform_namespace
    YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE
  end

  def step_transformer_name
    # If the owner is a constant then we get the name of the constant so that the reference from the constant will work
    if (owner.is_a?(YARD::CodeObjects::ConstantObject))
      owner.name
    else
      "step_transform#{self.class.generate_unique_id}"
    end
  end

  def self.generate_unique_id
    @step_transformer_count = @step_transformer_count.to_i + 1
  end

  private

  def find(node, node_type, value)
    node.traverse { |child| return(child) if node_type == child.type && child.source == value }
    self
  end
end