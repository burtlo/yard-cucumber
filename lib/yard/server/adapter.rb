module YARD
  module Server
    
    class Adapter
      
      class << self
      
        alias_method :yard_setup, :setup
      
        def setup
          yard_setup
          YARD::Templates::Engine.template_paths += 
          [File.dirname(__FILE__) + '/../../templates',File.dirname(__FILE__) + '/../../docserver']
        end
        
        alias_method :yard_shutdown, :shutdown

        def yard_shutdown
          YARD::Templates::Engine.template_paths -= 
          [File.dirname(__FILE__) + '/../../templates',File.dirname(__FILE__) + '/../../docserver']
        end  
        
      end
      

    end
    
  end
end
