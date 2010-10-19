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


def highlight_matches(step)
  
  value = h(step.value)
  
  if step.definition
    step.value.match(%r{#{step.definition.compare_value}}).to_a[1..-1].each do |match|
      value.gsub!(h(match),"<span class='match'>#{h(match)}</span>")
    end
  end
  
  value
end