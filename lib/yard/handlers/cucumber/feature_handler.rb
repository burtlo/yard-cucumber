module YARD
  module Handlers
    module Cucumber
      class FeatureHandler < Base

        handles CodeObjects::Cucumber::Feature

        @@step_definitions = nil
        @@step_transforms = nil
        
        def process

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
                #log.info "Processing Scenario: #{scenario.value}"
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


        def process_scenario(scenario)
          scenario.steps.each {|step| process_step(step) }
        end

        def process_step(step)
          match_step_to_step_definition_and_transforms(step)

        end

        def match_step_to_step_definition_and_transforms(step)
          @@step_definitions.each do |stepdef,stepdef_object|

            stepdef_matches = step.value.match(stepdef)

            if stepdef_matches
              step.definition = stepdef_object
              stepdef_matches[-1..1].each do |match|
                @@step_transforms.each do |steptrans,steptransform_object|
                  if steptrans.match(match)
                    step.transforms << steptransform_object
                    steptransform_object.steps << step
                  end
                end
              end
              
              # Step has been matched to step definition and step transforms
              break
              
            end

          end


        end
      end
    end
  end
end