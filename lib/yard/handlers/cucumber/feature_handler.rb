module YARD
  module Handlers
    module Cucumber

      class FeatureHandler < Base

        handles CodeObjects::Cucumber::Feature

        def process 

          if statement
            log.info "Processing Feature: #{statement.value}"
            # For the background and the scenario, find the steps that have definitions
            process_scenario(statement.background) if statement.background


            statement.scenarios.each do |scenario|
              if scenario.outline?
                log.info "Scenario Outline: #{scenario.value}"
                scenario.scenarios.each_with_index do |example,index|
                  log.info " * Processing Example #{index + 1}"
                  process_scenario(example)
                end
              else
                log.info "Processing Scenario: #{scenario.value}"
                process_scenario(scenario)
              end
            end
            
          else
            log.warn "Empty feature file.  A feature failed to process correctly or contains no feature"
          end

        rescue YARD::Handlers::NamespaceMissingError
        rescue Exception => exception
          log.error "Skipping feature because an error has occurred."
          log.debug "#\n{exception}\n#{exception.backtrace.join("\n")}\n"
        end



        def process_scenario(scenario)
          scenario.steps.each do |step|
            process_step(step)
          end
        end


        def process_step(step)
          step_definition = match_step_to_step_definition(step.value)
          
          if step_definition
            step.definition = step_definition
            find_transforms_for_step(step)
          end
        end


        def match_step_to_step_definition(step_value)
          YARD::Registry.all(:stepdefinition).each do |stepdef|
            #log.debug "Looking at step #{step_value} against #{stepdef}"

            if stepdef.compare_value =~ /.+\#\{[^\}]+\}.+/
              log.warn "Step definition has packed constant #{stepdef.compare_value}"
            else
              if %r{#{stepdef.compare_value}}.match(step_value)
                return stepdef
              end
            end
          end

          nil
        end
        
        def find_transforms_for_step(step)
          #log.debug "Looking at step #{step} for transforms"
          
          if step.definition
            
            step.value.match(%r{#{step.definition.compare_value}}).to_a.each do |match|
              YARD::Registry.all(:steptransform).each do |steptrans|
                #log.debug "Looking at transform #{steptrans.value}"
                if %r{#{steptrans.compare_value}}.match(match)
                  #log.debug "Step #{step} is affected by the transform #{steptrans}"
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