module YARD
  module Server
    
    class Adapter
      class << self
        
        alias_method :setup, :yard_setup
        
        def setup
          yard_setup
          YARD::Templates::Engine.register_template_path -= [File.dirname(__FILE__) + '/templates']
          YARD::Templates::Engine.register_template_path |= [File.dirname(__FILE__) + '/templates',File.dirname(__FILE__) + '/docserver']
        end
      
        alias_method :shutdon, :yard_shutdown
        
        def shutdown
          yard_shutdown
          YARD::Templates::Engine.register_template_path -= [File.dirname(__FILE__) + '/templates',File.dirname(__FILE__) + '/docserver']
        end

      end
    end
    
  end
end
