def init
  super
  sections.push :tagusage
  @tags = object
  
  @tag_usage = { :features => 0,
    :direct_scenarios => 0,
    :indirect_scenarios => 0 }
  
  @tags.tags.each do |tag|
    if tag.scenario
      @tag_usage[:direct_scenarios] += 1 
    else
      @tag_usage[:features] += 1
      @tag_usage[:indirect_scenarios] += tag.feature.scenarios.length
    end
  end
  
end