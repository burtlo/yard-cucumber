require 'gherkin/rubify'
require 'cucumber/parser/gherkin_builder'
require 'gherkin/parser/parser'
require 'gherkin/formatter/tag_count_formatter'

require 'yard'

module CucumberInTheYARD
  VERSION = '1.6.2' unless defined?(CucumberInTheYARD::VERSION)
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
require File.dirname(__FILE__) + "/yard/code_objects/namespace_object.rb"

require File.dirname(__FILE__) + "/yard/parser/cucumber/feature.rb"

require File.dirname(__FILE__) + "/yard/handlers/cucumber/base.rb"
require File.dirname(__FILE__) + "/yard/handlers/cucumber/feature_handler.rb"

require File.dirname(__FILE__) + "/yard/handlers/step_definition_handler.rb"
require File.dirname(__FILE__) + "/yard/handlers/step_transform_handler.rb"

require File.dirname(__FILE__) + "/yard/parser/source_parser.rb"
require File.dirname(__FILE__) + "/yard/templates/helpers/base_helper.rb"
require File.dirname(__FILE__) + "/yard/rake/city_task.rb"

