def init
  super
  @feature = object
    
  sections.push :feature
  
  sections.push :scenarios if object.scenarios
    
end

def background
  @scenario = @feature.background
  @id = "background"
  erb(:scenario)  
end

def scenarios
  scenarios = ""
  
  if @feature.background
    @scenario = @feature.background
    @id = "background"
    scenarios += erb(:scenario)
  end
  
  @feature.scenarios.each_with_index do |scenario,index|
    @scenario = scenario
    @id = "scenario_#{index}"
    scenarios += erb(:scenario)
  end
  
  scenarios
end


def highlight_matches(step)
  value = step.value.dup
  
  if step.definition
    matches = step.value.match(step.definition.regex)
    
    if matches
      matches[1..-1].reverse.each_with_index do |match,index|
        next if match == nil
        value[matches.begin((matches.size - 1) - index)..(matches.end((matches.size - 1) - index) - 1)] = "<span class='match'>#{h(match)}</span>"
      end
    end
  end
  
  value
end

def htmlify_with_newlines(text)
  text.split("\n").collect {|c| h(c).gsub(/\s/,'&nbsp;') }.join("<br/>")
end