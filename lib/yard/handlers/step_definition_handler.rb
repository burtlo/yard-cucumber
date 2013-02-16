#
# Finds and processes all the step definitions defined in the ruby source
# code. By default the english gherkin language will be parsed.
#
# To override the language you can define the step definitions in the YARD
# configuration file `~./yard/config`:
#
# @example `~/.yard/config` with LOLCatz step definitions
#
#     :"yard-cucumber":
#       language:
#         step_definitions: [ 'WEN', 'I CAN HAZ', 'AN', 'DEN' ]
#
# @example `~/.yard/config` with French step definitions
#
#     :"yard-cucumber":
#       language:
#         step_definitions: [ 'Soit', 'Etantdonné', 'Lorsque', 'Lorsqu', 'Alors', 'Et' ]
#
class YARD::Handlers::Ruby::StepDefinitionHandler < YARD::Handlers::Ruby::Base

  def self.default_step_definitions
    [ "When", "Given", "And", "Then" ]
  end

  def self.custom_step_definitions
    YARD::Config.options["yard-cucumber"]["language"]["step_definitions"]
  end

  def self.custom_step_definitions_defined?
    YARD::Config.options["yard-cucumber"] and
    YARD::Config.options["yard-cucumber"]["language"] and
    YARD::Config.options["yard-cucumber"]["language"]["step_definitions"]
  end

  def self.step_definitions
    if custom_step_definitions_defined?
      custom_step_definitions
    else
      default_step_definitions
    end
  end

  step_definitions.each { |step_def| handles method_call(step_def) }

  process do

    instance = YARD::CodeObjects::StepDefinitionObject.new(step_transform_namespace,step_definition_name) do |o|
      o.source = statement.source
      o.comments = statement.comments
      o.keyword = statement.method_name.source
      o.value = statement.parameters.source
      o.pending = pending_keyword_used?(statement.block)
    end

    obj = register instance
    parse_block(statement[2],:owner => obj)

  end

  def pending_keyword
    "pending"
  end

  def pending_command_statement?(line)
    (line.type == :command || line.type == :vcall) && line.first.source == pending_keyword
  end

  def pending_keyword_used?(block)
    code_in_block = block.last
    code_in_block.find { |line| pending_command_statement?(line) }
  end

  def step_transform_namespace
    YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE
  end

  def step_definition_name
    "step_definition#{self.class.generate_unique_id}"
  end

  def self.generate_unique_id
    @step_definition_count = @step_definition_count.to_i + 1
  end

end
