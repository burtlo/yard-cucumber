
module YARD::CodeObjects::Cucumber
  
  class NamespaceObject < YARD::CodeObjects::NamespaceObject
    include LocationHelper
    
    def value ; nil ; end
  end

  class FeatureDirectory < YARD::CodeObjects::NamespaceObject
    
    def location
      files.first.first if files && !files.empty?
    end

    def value ; name ; end
  end
  
  CUCUMBER_NAMESPACE = NamespaceObject.new(:root, "requirements")
  CUCUMBER_TAG_NAMESPACE = NamespaceObject.new(CUCUMBER_NAMESPACE, "tags")
  
  class StepTransformersObject < NamespaceObject ; end
  
  CUCUMBER_STEPTRANSFORM_NAMESPACE = StepTransformersObject.new(CUCUMBER_NAMESPACE, "step_transformers")
  
  
end