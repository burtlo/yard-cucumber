

module YARD::CodeObjects::Cucumber

  class Tag < NamespaceObject

    attr_accessor :value, :owners, :total_scenarios
    
    def features
      @owners.find_all{|owner| owner.is_a?(Feature) }
    end
    
    def scenarios
      all = @owners.find_all{|owner| owner.is_a?(Scenario) || owner.is_a?(ScenarioOutline) }
      @owners.each {|owner|
        if owner.is_a?(ScenarioOutline::Examples) && !all.include?(owner.scenario)
          all << owner.scenario
        end
      }
      return all
    end

    def indirect_scenarios
      @owners.find_all{|owner| owner.is_a?(Feature) }.collect {|feature| feature.scenarios }.flatten
    end
    
    def all_scenarios
      scenarios + indirect_scenarios
    end

  end

end
