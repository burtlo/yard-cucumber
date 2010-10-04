require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module YARD::CodeObjects

  describe YARD::CodeObjects do

    shared_examples_for "CodeObjects" do
      it "should respond to all defined attributes" do
        @attributes.each {|attribute| @object.should respond_to(attribute) }
      end
    end

    describe StepDefinitionObject do

      before(:each) do
        @attributes = [ :value, :predicate, :constants, :compare_value ]
        @object = StepDefinitionObject.new(:root,:unique_name)
      end

      class TestObject
        attr_accessor :name, :value
        def initialize ; yield self ; end
      end

      it_should_behave_like "CodeObjects"
      
      describe "compare_value" do

        [ { :value => "/THERE (?:IS|ARE) THREE \#\{ CONSTANTS \} IN HERE \#\{ FOR\} YOU TO \#\{FIND \}",
          :results => [ 'CONSTANTS', 'FOR', 'FIND' ] } ].each do |data|

            it "should find all the constants within the step definition" do
              
              stepdef = StepDefinitionObject.new(:root,"name")
              stepdef.value = data[:value]

              
              data[:results].each do |result|
                stepdef._value_constants(data[:value]).should include(result)
                stepdef._value_constants.should include(result)
              end
              
            end
          end
        
        
        [ { :value => "/WHEN THE \#\{NOUN\} HITS THE FAN/", 
                  :constants => [ TestObject.new{|c| c.name = "NOUN" ; c.value = "/SMURF/" } ], :result => "WHEN THE SMURF HITS THE FAN" },

                  { :value => "/\#\{ SUBJECT \} WALK INTO THE \#\{ PLACE\} AND ASK THE \#\{PERSON \}/", 
                  :constants => [ TestObject.new{|c| c.name = "SUBJECT" ; c.value = "/1 PERSON/" }, 
                    TestObject.new{|c| c.name = "PLACE" ; c.value = "/BAR/" },
                    TestObject.new{|c| c.name = "PERSON" ; c.value = "/BARTENDER/" } ], 
                    :result => "1 PERSON WALK INTO THE BAR AND ASK THE BARTENDER" },
                            
           ].each do |data|

          it "should replace all constants found within (#{data[:value]}) the value" do
            
            stepdef = StepDefinitionObject.new(:root,"name")
            stepdef.value = data[:value]
            stepdef.constants = data[:constants]
            
            stepdef.compare_value.should == data[:result]

          end

        end


      end
      
      

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

  describe YARD::Handlers::Ruby::Legacy do

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