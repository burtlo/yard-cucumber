module YARD
  module Handlers
    module Cucumber

      class FeatureHandler < Base
        
        handles CodeObjects::Cucumber::Feature

        def process 
          log.debug "FeatureHandler: #{statement.class}"
          
          statement.scenarios.each do |scenario|
            log.debug "Scenario: #{scenario}"
            
            scenario.steps.each do |step|
              log.info "Step: #{step}"
            end
            
          end
          
          
        rescue YARD::Handlers::NamespaceMissingError
        end
        
      end
            
    end
  end
end