module YARD
  module Handlers
    module Cucumber

      class FeatureHandler < Base

        handles CodeObjects::Cucumber::Feature

        def process 

          if statement
            # For the background and the scenario, find the steps that have definitions
            process_scenario(statement.background) if statement.background

            statement.scenarios.each do |scenario|
              process_scenario(scenario)
            end
          else
            log.warn "Empty feature file.  A feature failed to process correctly or contains no feature"
          end

        rescue YARD::Handlers::NamespaceMissingError
        end


        def process_scenario(scenario)
          scenario.steps.each do |step|
            process_step(step)
          end
        end


        def process_step(step)

          match_step_to_step_definition(step)
          find_transforms_for_step(step) if step.definition

        end


        def match_step_to_step_definition(step)
          YARD::Registry.all(:stepdefinition).each do |stepdef|
            #log.debug "Looking at step #{step} against #{stepdef}"

            if stepdef.compare_value =~ /.+\#\{[^\}]+\}.+/
              #log.debug "Step definition has packed constant #{stepdef.compare_value}"
            else
              if %r{#{stepdef.compare_value}}.match(step.value)
                step.definition = stepdef
                stepdef.steps << step
                #log.debug "STEP #{step} has found its definition #{stepdef}"
                break
              end
            end
          end
        end
        
        def find_transforms_for_step(step)
          #log.debug "Looking at step #{step} for transforms"
          
          if step.definition
            
            step.value.match(%r{#{step.definition.compare_value}}).to_a.each do |match|
              YARD::Registry.all(:steptransform).each do |steptrans|
                #log.debug "Looking at transform #{steptrans.value}"
                if %r{#{steptrans.compare_value}}.match(match)
                  log.debug "Step #{step} is affected by the transform #{steptrans}"
                  step.transforms << steptrans
                  steptrans.steps << step
                end
              end
              
            end
            
          end
          
        end



      end

    end
  end
end