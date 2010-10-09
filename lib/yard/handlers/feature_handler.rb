module YARD
  module Handlers
    module Cucumber

      class FeatureHandler < Base

        handles CodeObjects::Cucumber::Feature

        def process 
                    
          # Of the steps in the feature, find the step definitions that match
          
          statement.scenarios.each do |scenario|
            scenario.steps.each do |step|
              owner.step_definitions.each do |stepdef|
                if %r{#{stepdef.compare_value}}.match(step.value)
                  step.definition = stepdef
                  stepdef.steps << step
                  log.info "STEP #{step} has found its definition #{stepdef}"
                  break
                end

              end

            end
          end

        rescue YARD::Handlers::NamespaceMissingError
        end

      end

    end
  end
end