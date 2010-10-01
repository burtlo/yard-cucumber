
shared_examples_for "a feature file" do
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
  
  it "the feature's tags should have a file" do
    @parser.features.first.tags.each do |tag|
      tag.files.should_not be_nil
      tag.files.should_not be_empty
      tag.files.first.first.should == @feature[:file]
    end
  end

  it "the feature should have a description" do
    @parser.features.first.description.join("\n") == @feature[:description].join("\n")
  end

  it "the feature should have a file" do 
    @parser.features.first.files.first[0].should == @feature[:file]
  end

  it "the feature should have a line number" do
    @parser.features.first.files.first[1].should_not be_nil
  end

end

shared_examples_for "a feature file with a background" do

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

  it "the background should have a line number" do
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
  
  it "the background steps should have files and line numbers" do
    if @background
      @background.each_with_index do |step,index|
        @parser.features.first.background.steps[index].files.first[0].should == @feature[:file]
        @parser.features.first.background.steps[index].files.first[1].should_not be_nil
      end
    end
  end

end

shared_examples_for "a feature file with scenarios" do
  it "should have all scenarios" do
    @scenarios.each_with_index do |scenario,index|
      @parser.features.first.scenarios[index].should_not be_nil  
    end
  end

  it "each scenario should have a unique scenario name" do
    @parser.features.first.scenarios.first.name.should == "#{@feature[:file]}_scenario_0".gsub('.','_').to_sym
  end

  it "each scenario should have the correct title" do
    @parser.features.first.scenarios.each_with_index do |scenario,index|
      scenario.value.should == @scenarios[index][:title].join("\n")
    end  
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

  it "each scenario's steps should have files and line numbers" do
    if @scenarios
      @scenarios.each_with_index do |scenario,scenario_index|
        scenario[:steps].each_with_index do |step,step_index|
          @parser.features.first.scenarios[scenario_index].steps[step_index].files.first[0].should == @feature[:file]
          @parser.features.first.scenarios[scenario_index].steps[step_index].files.first[1].should_not be_nil
        end
      end
    end
  end
  
end