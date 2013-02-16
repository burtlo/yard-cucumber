module YARD
  module Handlers
    module Cucumber

      class Base < Handlers::Base
        class << self
          include Parser::Cucumber
          def handles?(node)
            handlers.any? do |a_handler|
              #log.debug "YARD::Handlers::Cucumber::Base#handles?(#{node.class})"
              node.class == a_handler
            end
          end
          include Parser::Cucumber
        end
      end

      Processor.register_handler_namespace :feature, Cucumber
    end
  end
end
