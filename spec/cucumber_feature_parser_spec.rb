
module YARD::Parser::Cucumber

  shared_examples_for "basic feature file" do
    it "should have found the feature" do
      @parser.features.first.should_not be_nil
    end

    it "should have a unique name" do
      @parser.features.first.name.should == FEATURE_FILE_NAME.gsub('.','_').to_sym
    end

    it "should have a value for the feature" do
      @parser.features.first.value.should == FEATURE_NAME
    end

    it "should have found the tags" do
      @parser.features.first.tags.should include("@bvt")
      @parser.features.first.tags.should include("@build")
      @parser.features.first.tags.should include("@wip")
    end

    it "should have a description" do
      @parser.features.first.description.join("\n") == "This feature is going to save the company."
    end

    it "should have a file" do 
      @parser.features.first.files.first[0].should == FEATURE_FILE_NAME
    end

    it "should have a line number" do
      @parser.features.first.files.first[1].should_not be_nil
    end

  end

  shared_examples_for "with a background" do

    it "should have a background" do
      @parser.features.first.background.should_not be_nil
    end

    it "should have a unique scenario name" do
      @parser.features.first.background.name.should == "#{FEATURE_FILE_NAME}.background".gsub('.','_').to_sym
    end

    it "should have a value for the scenario" do
      @parser.features.first.background.value.should == "Background"  
    end

    it "should have a file" do
      @parser.features.first.background.files.first[0].should == FEATURE_FILE_NAME
    end

    it "should have a line number" do
      @parser.features.first.background.files.first[1].should_not be_nil
    end



  end

  describe "Feature Parser" do

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

    context "while parsing a file with tags, a feature, and a description" do

      FEATURE_NAME = "New Exciting Feature"
      FEATURE_FILE_NAME = "new.exciting.feature"

      before(:each) do
        @parser = FeatureParser.new(%{
          @bvt @build @wip
          Feature: #{FEATURE_NAME}
          This feature is going to save the company.
          },FEATURE_FILE_NAME)

          @parser = @parser.parse
          #puts @parser.source
        end

        after(:each) do
          @parser = nil
        end

        it_should_behave_like "basic feature file"

      end

      context "while parsing a file with step definitions" do

        FEATURE_NAME = "New Exciting Feature"
        FEATURE_FILE_NAME = "new.exciting.feature"

        before(:each) do
          @parser = FeatureParser.new(%{
            @bvt @build @wip
            Feature: #{FEATURE_NAME}
            This feature is going to save the company.

            Background:
            Given that I have taken a nap

            @ninja
            Scenario: Ninja striking an opponent in the morning
            Given that there is an opponent
            And a reason to fight him
            When I karate strike hime
            Then I expect him to fall
            },FEATURE_FILE_NAME)

            @parser = @parser.parse
            #puts @parser.source
          end

          after(:each) do
            @parser = nil
          end

          it_should_behave_like "basic feature file"
          it_should_behave_like "with a background"

          it "should have a scenario" do 
            @parser.features.first.scenarios.first.should_not be_nil
          end

          it "should have a unique scenario name" do
            @parser.features.first.scenarios.first.name.should == "#{FEATURE_FILE_NAME}_scenario_0".gsub('.','_').to_sym
          end

          it "should have a value for the scenario" do
            @parser.features.first.scenarios.first.value.should == "Ninja striking an opponent in the morning"  
          end
          
          it "should have tags" do
            @parser.features.first.scenarios.first.tags.should include("@ninja")
          end
          
          it "should have a file" do
            @parser.features.first.scenarios.first.files.first[0].should == FEATURE_FILE_NAME
          end
          
          it "should have a line number" do
            @parser.features.first.scenarios.first.files.first[1].should_not be_nil
          end

        end

      end
    end
