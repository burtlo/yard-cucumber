
describe "Feature Parser" do
  
  it "should accept source and a file when created" do
    
    lambda { YARD::Parser::Cucumber::FeatureParser.new("source code","filename") }.should_not raise_exception(Exception)
    
  end
  
end