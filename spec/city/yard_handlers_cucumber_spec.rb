require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module YARD::Handlers::Cucumber

  describe Base do
    
    it "should respond to method handles?" do
      Base.should respond_to(:handles?)
    end
    
  end
  
  describe FeatureHandler do
    
    it "should respond to method process" do
      FeatureHandler.should respond_to(:process)  
    end
    
  end
  
  
  
  
end