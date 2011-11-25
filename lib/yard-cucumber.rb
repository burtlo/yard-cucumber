require 'cucumber/parser/gherkin_builder'
require 'gherkin/parser/parser'
require 'gherkin/formatter/tag_count_formatter'


module CucumberInTheYARD
  VERSION = '2.1.6'
end

require File.dirname(__FILE__) + "/yard/code_objects/cucumber/base.rb"
require File.dirname(__FILE__) + "/yard/code_objects/cucumber/namespace_object.rb"
require File.dirname(__FILE__) + "/yard/code_objects/cucumber/feature.rb"
require File.dirname(__FILE__) + "/yard/code_objects/cucumber/scenario_outline.rb"
require File.dirname(__FILE__) + "/yard/code_objects/cucumber/scenario.rb"
require File.dirname(__FILE__) + "/yard/code_objects/cucumber/step.rb"
require File.dirname(__FILE__) + "/yard/code_objects/cucumber/tag.rb"

require File.dirname(__FILE__) + "/cucumber/city_builder.rb"

require File.dirname(__FILE__) + "/yard/code_objects/step_transformer.rb"
require File.dirname(__FILE__) + "/yard/code_objects/step_definition.rb"
require File.dirname(__FILE__) + "/yard/code_objects/step_transform.rb"

require File.dirname(__FILE__) + "/yard/parser/cucumber/feature.rb"

require File.dirname(__FILE__) + "/yard/handlers/cucumber/base.rb"
require File.dirname(__FILE__) + "/yard/handlers/cucumber/feature_handler.rb"

if RUBY19
  require File.dirname(__FILE__) + "/yard/handlers/step_definition_handler.rb"
  require File.dirname(__FILE__) + "/yard/handlers/step_transform_handler.rb"
end

require File.dirname(__FILE__) + "/yard/handlers/legacy/step_definition_handler.rb"
require File.dirname(__FILE__) + "/yard/handlers/legacy/step_transform_handler.rb"

#require File.dirname(__FILE__) + "/yard/parser/source_parser.rb"
require File.dirname(__FILE__) + "/yard/templates/helpers/base_helper.rb"

require File.dirname(__FILE__) + "/yard/server/adapter.rb"
require File.dirname(__FILE__) + "/yard/server/commands/list_command.rb"
require File.dirname(__FILE__) + "/yard/server/router.rb"


# This registered template works for yardoc
YARD::Templates::Engine.register_template_path File.dirname(__FILE__) + '/templates'

# The following static paths and templates are for yard server
YARD::Server.register_static_path File.dirname(__FILE__) + "/templates/default/fulldoc/html"
YARD::Server.register_static_path File.dirname(__FILE__) + "/docserver/default/fulldoc/html"
