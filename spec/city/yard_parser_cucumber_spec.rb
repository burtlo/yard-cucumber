require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/feature_parser_spec_examples.rb'

module YARD::Parser::Cucumber

  describe Tag do
    
    [:value].each do |attribute|
      it "should respond to method #{attribute}" do
        Tag.new(:root,"tag_name").should respond_to(attribute)
      end
    end
    
  end

  describe Step do
    
    [:value, :definition].each do |attribute|
      it "should respond to method #{attribute}" do
        Step.new(:root,"name").should respond_to(attribute)
      end
    end
    
    it "should return the line prefix and the remainder" do
      step = Step.new(:root,"name") {|s| s.value = "Given something something" }
      step.predicate.should == "Given"
      step.line.should == "something something"
    end
    
  end
  
  describe Scenario do
    
    [:value, :description, :steps, :tags ].each do |attribute|
      it "should respond to method #{attribute}" do
        Scenario.new(:root,"name").should respond_to(attribute)
      end
    end
    
  end
  
  describe Feature do
    
    [:value, :description, :scenarios, :background, :tags ].each do |attribute|
      it "should respond to method #{attribute}" do
        Feature.new(:root,"name").should respond_to(attribute)
      end
    end
    
  end
  

  describe FeatureParser do


    it "should accept source and a file when created" do
      lambda { FeatureParser.new("source code","filename") }.should_not raise_exception(Exception)
    end

    [ "parse", "tokenize", "enumerator" ].each do |required_method|
      it "should have a method named #{required_method}" do
        FeatureParser.instance_methods.should include(required_method)
      end
    end

    it "should return itself when parse is called" do
      parser = FeatureParser.new("source","filename")
      parser.parse.should == parser
    end

    context "feature file with tags, feature, and description" do

      before(:all) do
        @feature = { :file => 'new.exciting.feature',
          :name => "New Exciting Feature", 
          :tags => [ "@bvt", "@build", "@wip" ],
          :description => [ "This feature is going to save the company." ] }
        
        @parser = FeatureParser.new(%{
          #{@feature[:tags].join(" ")}
          Feature: #{@feature[:name]}
          #{@feature[:description].join("\n")}
          },@feature[:file])

          @parser = @parser.parse
      end

      after(:all) do
        @parser = nil
      end

      it_should_behave_like "a feature file"

    end
    
    context "feature file with a description that uses step keywords" do

      before(:all) do
        @feature = { :file => 'description.with.keywords.feature',
          :name => "Fully Described Feature", 
          :tags => [ "@bvt", "@build", "@wip" ],
          :description => ["As a product owner",
            "When I ask about the work done",
            "Then I want to see what this cukes things is all about",
            "And I really want a straight answer",
            "Given that I can be provided with one"] }
        
        @parser = FeatureParser.new(%{
          #{@feature[:tags].join(" ")}
          Feature: #{@feature[:name]}
          #{@feature[:description].join("\n")}
          },@feature[:file])

          @parser = @parser.parse
      end

      after(:all) do
        @parser = nil
      end

      it_should_behave_like "a feature file"

    end
    

    context "feature file with background and one scenario" do

      before(:all) do

        @feature = { :file => "ninja.exciting.feature",
          :name => "Ninja Feature Set", 
          :tags => [ "@bvt", "@build", "@wip" ],
          :description => ["This feature is going to save the company"] }

        @background = [ "Given that I have taken a nap" ]
          
        @scenarios = [ { :tags => ["@ninja"],
          :title => ["Ninja striking an opponent in the morning"],
          :steps => [ "Given that there is an opponent", 
          "And a reason to fight him", 
          "When I karate strike him", 
          "Then I expect him to fall" ] } ]

          @parser = FeatureParser.new(%{
            #{@feature[:tags].join(" ")}
            Feature: #{@feature[:name]}
            #{@feature[:description].join("\n")}
              Background:
            #{@background.join("\n")}
              #{@scenarios.first[:tags].join(" ")}
            Scenario: #{@scenarios.first[:title].join("\n")}
            #{@scenarios.first[:steps].join("\n")}
            },@feature[:file])
          @parser = @parser.parse
      end
            
      after(:all) do
        @parser = nil
      end

      it_should_behave_like "a feature file"
      it_should_behave_like "a feature file with a background"
      it_should_behave_like "a feature file with scenarios"
            
    end

    context "feature file no background and multiple scenarios" do

      before(:all) do

        @feature = { :file => "ninja.strike.feature",
          :name => "Ninja Feature Set", 
          :tags => [ "@kill", "@silently", "@sneak" ],
          :description => ["This feature is going to save the company"] }

        @scenarios = [  
          { :tags => ["@ninja"], 
            :title => ["Killing Scenario"],
            :steps => [ "Given that there is an opponent", 
                        "And a reason to fight him", 
                        "When I karate strike him", 
                        "Then I expect him to fall" ] },
          { :tags => [], 
            :title => ["Dissappearing Scenario"],
            :steps => [ "Given that I have defeated an opponent", 
                        "And there are no more opponents", 
                        "When I stop to take a breath", 
                        "Then I expect to dissapear" ] } ]

          @parser = FeatureParser.new(%{
            #{@feature[:tags].join(" ")}
            Feature: #{@feature[:name]}
            #{@feature[:description].join("\n")} 
            #{@scenarios.collect {|scenario|
              scenario[:tags].join(" ") + 
              "\nScenario: " + scenario[:title].join("\n") + "\n" +
              scenario[:steps].join("\n")  
            }.join("\n")}},@feature[:file])
          @parser = @parser.parse
      end
            
      after(:all) do
        @parser = nil
      end

      it_should_behave_like "a feature file"
      it_should_behave_like "a feature file with scenarios"
            
    end



  end
  
end
