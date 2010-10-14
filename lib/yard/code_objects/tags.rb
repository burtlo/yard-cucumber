

module YARD::CodeObjects::Cucumber

  class Tag < Base

    attr_accessor :value, :owners
    
    
    def scenario_count
      @owners.find_all{|owner| owner.is_a?(Scenario) }.size
    end
    
    def feature_count
      @owners.find_all{|owner| owner.is_a?(Feature) }.size
    end
    
    def indirect_scenario_count
      scenarios = 0
      @owners.find_all{|owner| owner.is_a?(Feature) }.each {|feature| scenarios += feature.scenarios.size }
      scenarios
    end
    
    def total_scenario_count
      scenario_count + indirect_scenario_count
    end
    
    
  end

end
