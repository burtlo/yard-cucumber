module YARD::Templates::Helpers

  module BaseHelper

    alias_method :yard_format_object_title, :format_object_title

    #
    # Alias around for this method to get the correct titles
    #
    def format_object_title(object)
      if object.is_a?(YARD::CodeObjects::Cucumber::NamespaceObject)
        "#{format_object_type(object)}#{object.value ? ": #{object.value}" : ''}"
      else
        yard_format_object_title(object)
      end
    end
    
  end

end  
