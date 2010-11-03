
module YARD::CodeObjects::Cucumber
  
  class NamespaceObject < YARD::CodeObjects::NamespaceObject
    include LocationHelper
    def value ; nil ; end
  end

  class Requirements < NamespaceObject ; end
  class Tags < NamespaceObject ; end
  class StepTransformersObject < NamespaceObject ; end

  class FeatureDirectory < YARD::CodeObjects::NamespaceObject
    
    def location
      files.first.first if files && !files.empty?
    end

    def value ; name ; end
  end

  CUCUMBER_NAMESPACE = Requirements.new(:root, "requirements")
  
  CUCUMBER_TAG_NAMESPACE = Tags.new(CUCUMBER_NAMESPACE, "tags")
  
  CUCUMBER_STEPTRANSFORM_NAMESPACE = StepTransformersObject.new(CUCUMBER_NAMESPACE, "step_transformers")
  
end