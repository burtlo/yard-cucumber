
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

    shared_examples_for "basic feature file" do
      it "should have a defined feature" do
        @parser.features.first.should_not be_nil
      end

      it "the feature should have a unique name" do
        @parser.features.first.name.should == @feature[:file].gsub('.','_').to_sym
      end

      it "the feature should have the specified title" do
        @parser.features.first.value.should == @feature[:name]
      end

      it "the feature should have all specified tags" do
        @feature[:tags].find do |expected_tag|
          @parser.features.first.tags.find{|tag| tag.value == expected_tag }
        end.should_not be_nil
      end
      
      it "the feature should have the correct number of tags" do
        @feature[:tags].each do |expected_tag|
          @parser.features.first.tags.find_all {|tag| tag.value == expected_tag }.count.should == 1
        end
      end

      it "the feature should have a description" do
        @parser.features.first.description.join("\n") == "This feature is going to save the company."
      end

      it "the feature should have a file" do 
        @parser.features.first.files.first[0].should == @feature[:file]
      end

      it "the feature should have a line number" do
        @parser.features.first.files.first[1].should_not be_nil
      end

    end

    shared_examples_for "with a background" do

      it "the feature should have a background" do
        @parser.features.first.background.should_not be_nil
      end

      it "the background should have a unique scenario name" do
        @parser.features.first.background.name.should == "#{@feature[:file]}.background".gsub('.','_').to_sym
      end

      it "the background should have the correct title" do
        @parser.features.first.background.value.should == "Background"  
      end

      it "the background should have a file" do
        @parser.features.first.background.files.first[0].should == @feature[:file]
      end

      it "the backgroundshould have a line number" do
        @parser.features.first.background.files.first[1].should_not be_nil
      end

      it "the background should have all their defined steps" do
        @parser.features.first.scenarios.first.steps.should_not be_nil
        if @background
          @background.each_with_index do |step,index|
            @parser.features.first.background.steps[index].value.should == step
          end
        end
      end

    end

    shared_examples_for "with scenarios" do
      it "should have all scenarios" do
        @scenarios.each_with_index do |scenario,index|
          @parser.features.first.scenarios[index].should_not be_nil  
        end
      end

      it "each scenario should have a unique scenario name" do
        @parser.features.first.scenarios.first.name.should == "#{@feature[:file]}_scenario_0".gsub('.','_').to_sym
      end

      it "each scenario should have the correct title" do
        @parser.features.first.scenarios.first.value.should == "Ninja striking an opponent in the morning"  
      end

      it "each scenario should have the correct tags" do
        @scenarios.each_with_index do |scenario,index|
          scenario[:tags].each do |expeced_tag|
            @parser.features.first.scenarios[index].tags.find {|tag| tag.value == expeced_tag}.should_not be_nil
          end
        end
      end

      it "each scenario should have the correct number of tags" do
        @parser.features.first.scenarios.first.tags.find_all {|tag| tag.value == "@ninja" }.count.should == 1
      end

      it "each scenario should have a file" do
        @parser.features.first.scenarios.first.files.first[0].should == @feature[:file]
      end

      it "each scenario should have a line number" do
        @parser.features.first.scenarios.first.files.first[1].should_not be_nil
      end

      it "each scenario should have all their defined steps" do
        @parser.features.first.scenarios.first.steps.should_not be_nil
        if @scenarios
          @scenarios.each_with_index do |scenario,scenario_index|
            @parser.features.first.scenarios[scenario_index].should_not be_nil

            scenario[:steps].each_with_index do |step,step_index|
              @parser.features.first.scenarios[scenario_index].steps[step_index].name.should == "#{@feature[:file].gsub('.','_')}_scenario_#{scenario_index}_step_#{step_index}".to_sym
              @parser.features.first.scenarios[scenario_index].steps[step_index].value.should == step
            end
          end
        end
      end
    end


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

      before(:all) do
        @feature = { :file => 'new.exciting.feature',
          :name => "New Exciting Feature", 
          :tags => [ "@bvt", "@build", "@wip" ] }
        
        @parser = FeatureParser.new(%{
          #{@feature[:tags].join(" ")}
          Feature: #{@feature[:name]}
          This feature is going to save the company.
          },@feature[:file])

          @parser = @parser.parse
        end

        after(:all) do
          @parser = nil
        end

        it_should_behave_like "basic feature file"

      end

      context "while parsing a file with step definitions" do

        before(:all) do

          @feature = { :file => "ninja.exciting.feature",
            :name => "Ninja Feature Set", 
            :tags => [ "@bvt", "@build", "@wip" ] }

          @background = [ "Given that I have taken a nap" ]
          
          @scenarios = [ { :tags => ["@ninja"],
            :steps => [ "Given that there is an opponent", 
            "And a reason to fight him", 
            "When I karate strike him", 
            "Then I expect him to fall" ] } ]

            @parser = FeatureParser.new(%{
              #{@feature[:tags].join(" ")}
              Feature: #{@feature[:name]}
              This feature is going to save the company.

              Background:
              #{@background.join("\n")}

              #{@scenarios.first[:tags].join(" ")}
              Scenario: Ninja striking an opponent in the morning
              #{@scenarios.first[:steps].join("\n")}
              },@feature[:file])

              @parser = @parser.parse
            end

            after(:all) do
              @parser = nil
            end

            it_should_behave_like "basic feature file"
            it_should_behave_like "with a background"
            it_should_behave_like "with scenarios"
            
          end

        end
      end
