require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Gherkin" do


  before(:all) do
    
    @source = File.dirname(__FILE__) + '/test.feature'
    File.should exist(@source)
    @data = File.open(@source, 'r').read
    
    @parser = YARD::Parser::Cucumber::FeatureParser.new(@data,@source)
  
  end


  it "should not be nil" do
    @parser.should_not be_nil
  end

  it "should parse" do
    @parser.parse
  end
  
  it "should tokenize" do
    @parser.tokenize
  end
  
  it "should enumerator" do
    @parser.enumerator
  end
    






end