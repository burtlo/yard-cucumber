module YARD
  module Handlers
    module Cucumber

      class FeatureHandler < Base
        
        handles CodeObjects::Cucumber::Feature

        def process 
          log.debug "FeatureHandler Online #{statement}"
        rescue YARD::Handlers::NamespaceMissingError
        end
        
      end
            
    end
  end
end