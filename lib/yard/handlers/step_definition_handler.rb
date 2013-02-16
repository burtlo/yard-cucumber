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
      o.pending = keyword_used_in_block?(statement.block,pending_keyword)
      o.substeps = all_keywords_uses_in_block?(statement.block,step_keyword)
    end

    obj = register instance
    parse_block(statement[2],:owner => obj)

  end

  def pending_keyword
    "pending"
  end

  def step_keyword
    "step"
  end

  def keyword_used_in_block?(block,keyword)
    code_in_block = block.last
    code_in_block.find { |line| command_statement_used?(line,keyword) }
  end

  def all_keywords_uses_in_block?(block,keyword)
    code_in_block = block.last
    code_in_block.find_all { |line| command_statement_used?(line,keyword) }
  end

  def command_statement_used?(line,keyword)
    (line.type == :command || line.type == :vcall) && line.first.source == keyword
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
