module YARD::Templates::Helpers

  module BaseHelper

    def format_object_title(object)
      if object.is_a?(YARD::CodeObjects::Cucumber::NamespaceObject)
        "#{format_object_type(object)}#{object.value ? ": #{object.value}" : ''}"
      else
        case object
        when YARD::CodeObjects::RootObject
          "Top Level Namespace"
        else
          format_object_type(object) + ": " + object.path
        end
      end
    end
    
  end

end  
