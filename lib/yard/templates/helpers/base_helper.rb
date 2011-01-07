module YARD::Templates::Helpers

  module BaseHelper

    def format_object_title(object)
      if object.is_a?(YARD::CodeObjects::Cucumber::FeatureTags)
        "Tags"
      elsif object.is_a?(YARD::CodeObjects::Cucumber::StepTransformersObject)
        "Step Definitions and Transforms"
      elsif object.is_a?(YARD::CodeObjects::Cucumber::NamespaceObject)
        "#{format_object_type(object)}#{object.value ? ": #{object.value}" : ''}"
      elsif object.is_a?(YARD::CodeObjects::Cucumber::FeatureDirectory)
        "Feature Directory: #{object.name}"
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
