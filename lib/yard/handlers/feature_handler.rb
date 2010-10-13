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
            owner.step_definitions.each do |stepdef|
              
              if stepdef.compare_value =~ /.+\#\{[^\}]+\}.+/
                #log.debug "Step definition has packed constant #{stepdef.compare_value}"
              else
                if %r{#{stepdef.compare_value}}.match(step.value)
                  step.definition = stepdef
                  stepdef.steps << step
                  log.debug "STEP #{step} has found its definition #{stepdef}"
                  break
                end
              end
            end
          end
            
        end
        

      end

    end
  end
end