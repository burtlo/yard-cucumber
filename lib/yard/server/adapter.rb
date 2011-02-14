module YARD
  module Server
    
    class Adapter
      
      class << self
      
        alias_method :yard_setup, :setup
      
        #
        # To provide the templates necessary for `yard-cucumber` to integrate
        # with YARD the adapter has to around-alias the setup method to place
        # the `yard-cucumber` server templates as the last template in the list.
        #
        # When they are normally loaded with the plugin they cause an error with 
        # the `yardoc` command. They are also not used because the YARD server
        # templates are placed after all plugin templates. 
        #
        def setup
          yard_setup
          YARD::Templates::Engine.template_paths += 
          [File.dirname(__FILE__) + '/../../templates',File.dirname(__FILE__) + '/../../docserver']
        end
        
        alias_method :yard_shutdown, :shutdown

        #
        # Similar to the addition, it is good business to tear down the templates
        # that were added by again around-aliasing the shutdown method.
        #
        def shutdown
          yard_shutdown
          YARD::Templates::Engine.template_paths -= 
          [File.dirname(__FILE__) + '/../../templates',File.dirname(__FILE__) + '/../../docserver']
        end  
        
      end
      

    end
    
  end
end
