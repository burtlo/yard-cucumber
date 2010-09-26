
module YARD::CodeObjects

  context YARD::CodeObjects do

    shared_examples_for "CodeObjects" do
      it "should respond to all defined attributes" do
        @attributes.each {|attribute| @object.should respond_to(attribute) }
      end
    end

    describe StepDefinitionObject do

      before(:each) do
        @attributes = [ :value, :predicate, :constants ]
        @object = StepDefinitionObject.new(:root,:unique_name)
      end

      it_should_behave_like "CodeObjects"

    end

    describe StepTransformObject do

      before(:each) do
        @attributes = [ :value ]
        @object = StepTransformObject.new(:root,:unique_name)
      end

      it_should_behave_like "CodeObjects"

    end

  end

end

module YARD::Handlers::Ruby::Legacy

  context YARD::Handlers::Ruby::Legacy do

    shared_examples_for "Handlers" do
      it "should match #{@match_criteria}" do
        @handler::MATCH.should == @match_criteria
      end

      it "should respond to the method process" do
        @handler.should respond_to(:process)
      end

    end

    describe StepDefinitionHandler do
      before(:each) do
        @handler = StepDefinitionHandler
        @match_criteria = /^((When|Given|And|Then)\s*(\/[^\/]+\/).+)$/
      end
      
      it_should_behave_like "Handlers"
    end
    
    describe StepTransformHandler do
      before(:each) do
        @handler = StepTransformHandler
        @match_criteria = /^Transform\s*(\/[^\/]+\/).+$/
      end
      
      it_should_behave_like "Handlers"
    end


  end

end