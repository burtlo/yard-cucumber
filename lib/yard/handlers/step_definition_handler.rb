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

  #
  # By default the english gherkin language will be parsed, however, if the
  # YARD configuration file `~./yard/config` defines different step definition
  # handlers those are used.
  #
  #
  if YARD::Config.options["yard-cucumber"] and
    YARD::Config.options["yard-cucumber"]["language"] and
    YARD::Config.options["yard-cucumber"]["language"]["step_definitions"]

    YARD::Config.options["yard-cucumber"]["language"]["step_definitions"].each do |step_word|
      handles method_call(step_word.to_sym)
    end

  else
    handles method_call(:When),method_call(:Given),method_call(:And),method_call(:Then)
  end


  @@unique_name = 0

  process do
    @@unique_name += 1

    instance = YARD::CodeObjects::StepDefinitionObject.new(YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE,"step_definition#{@@unique_name}") do |o|
      o.source = statement.source
      o.comments = statement.comments
      o.keyword = statement[0].source
      o.value = statement[1].source
    end

    obj = register instance
    parse_block(statement[2],:owner => obj)

  end

end
