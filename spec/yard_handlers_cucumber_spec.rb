module YARD::Handlers::Cucumber

  context Base do
    
    it "should respond to method handles?" do
      Base.should respond_to(:handles?)
    end
    
  end
  
  context FeatureHandler do
    
    it "should respond to method process" do
      FeatureHandler.should respond_to(:process)  
    end
    
  end
  
  
  
  
end