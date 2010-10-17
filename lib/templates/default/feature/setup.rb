def init
  super
  @feature = object
    
  sections.push :feature
  
  sections.push :background if object.background
  sections.push :scenarios if object.scenarios  
    
end

def background
  @scenario = @feature.background
  @id = "background"
  erb(:scenario)  
end

def scenarios
  scenarios = ""
  
  @feature.scenarios.each_with_index do |scenario,index|
    @scenario = scenario
    @id = "scenario#{index}"
    scenarios += erb(:scenario)
  end
  
  scenarios
end