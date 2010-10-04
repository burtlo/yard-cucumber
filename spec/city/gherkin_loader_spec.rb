require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Gherkin" do
  
  
  before(:all) do
    
    @parser = Cucumber::Parser::GherkinBuilder.new
    
    
  end
  
  
  it "should not be nil" do
    
    @parser.should_not be_nil
    
  end
  



  

end