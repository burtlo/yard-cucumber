module YARD
  module Handlers
    module Cucumber
      class FeatureHandler < Base

        handles CodeObjects::Cucumber::Feature

        def process
          #
          # Features have already been created when they were parsed. So there
          # is no need to process the feature further. Previously this is where
          # feature steps were matched to step definitions and step definitions
          # were matched to step transforms. This only worked if the feature
          # files were were assured to be processed last which was accomplished
          # by overriding YARD::SourceParser to make it load file in a similar
          # order as Cucumber.
          #
          # As of YARD 0.7.0 this is no longer necessary as there are callbacks
          # that can be registered after all the files have been loaded. That
          # callback _after_parse_list_ is defined below and performs the
          # functionality described above.
          #
        end

        #
        # Register, once, when that when all files are finished to perform
        # the final matching of feature steps to step definitions and step
        # definitions to step transforms.
        #
        YARD::Parser::SourceParser.after_parse_list do |files,globals|
          # For every feature found in the Registry, find their steps and step
          # definitions...
          YARD::Registry.all(:feature).each do |feature|
            log.debug "Finding #{feature.file} - steps, step definitions, and step transforms"
            FeatureHandler.match_steps_to_step_definitions(feature)
          end

        end

        class << self

          @@step_definitions = nil
          @@step_transforms = nil

          def match_steps_to_step_definitions(statement)
            # Create a cache of all of the step definitions and the step transforms
            @@step_definitions = cache(:stepdefinition) unless @@step_definitions
            @@step_transforms = cache(:steptransform) unless @@step_transforms

            if statement
              # For the background and the scenario, find the steps that have definitions
              process_scenario(statement.background) if statement.background

              statement.scenarios.each do |scenario|
                if scenario.outline?
                  #log.info "Scenario Outline: #{scenario.value}"
                  scenario.scenarios.each_with_index do |example,index|
                    #log.info " * Processing Example #{index + 1}"
                    process_scenario(example)
                  end
                else
                  process_scenario(scenario)
                end
              end


            else
              log.warn "Empty feature file.  A feature failed to process correctly or contains no feature"
            end

          rescue YARD::Handlers::NamespaceMissingError
          rescue Exception => exception
            log.error "Skipping feature because an error has occurred."
            log.debug "\n#{exception}\n#{exception.backtrace.join("\n")}\n"
          end

          #
          # Store all comparable items with their compare_value as the key and the item as the value
          # - Reject any compare values that contain escapes #{} as that means they have unpacked constants
          #
          def cache(type)
            YARD::Registry.all(type).inject({}) do |hash,item|
              hash[item.regex] = item if item.regex
              hash
            end
          end

          # process a scenario
          def process_scenario(scenario)
            scenario.steps.each {|step| process_step(step) }
          end

          # process a step
          def process_step(step)
            match_step_to_step_definition_and_transforms(step)
          end

          #
          # Given a step object, attempt to match that step to a step
          # transformation
          #
          def match_step_to_step_definition_and_transforms(step)
            @@step_definitions.each_pair do |stepdef,stepdef_object|
              stepdef_matches = step.value.match(stepdef)

              if stepdef_matches
                step.definition = stepdef_object
                stepdef_matches[1..-1].each do |match|
                  @@step_transforms.each do |steptrans,steptransform_object|
                    if steptrans.match(match)
                      step.transforms << steptransform_object
                      steptransform_object.steps << step
                    end
                  end
                end

                # Step has been matched to step definition and step transforms
                # TODO: If the step were to match again then we would be able to display ambigous step definitions
                break

              end

            end

          end

        end
      end
    end
  end
end