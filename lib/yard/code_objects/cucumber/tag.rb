

module YARD::CodeObjects::Cucumber

  class Tag < NamespaceObject

    attr_accessor :value, :owners
    
    def features
      @owners.find_all{|owner| owner.is_a?(Feature) }
    end
    
    def scenarios
      @owners.find_all{|owner| owner.is_a?(Scenario) || owner.is_a?(ScenarioOutline) }
    end
        
    def indirect_scenarios
      @owners.find_all{|owner| owner.is_a?(Feature) }.collect {|feature| feature.scenarios }.flatten
    end
    
    def all_scenarios
      scenarios + indirect_scenarios
    end
    
  end

end
