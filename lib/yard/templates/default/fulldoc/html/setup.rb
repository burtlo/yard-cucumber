include YARD::Templates::Helpers::HtmlHelper

def init
  super
  asset("js/cucumber.js",file("js/cucumber.js",true))

  @features = Registry.all(:feature)

  if @features
    @features.each {|feature| serialize(feature) } 
    generate_full_list(@features)
  end

  
  @tags = Registry.all(:tag)
  
  if @tags
    @tags.each {|tag| log.debug "#{tag.name}" }
    
    @tags.each {|tag| serialize(tag) }
    generate_full_list @tags.sort {|x,y| y.total_scenario_count <=> x.total_scenario_count }
  end

  @scenarios = Registry.all(:scenario).find_all {|scenario| !scenario.background? }
  generate_full_list(@scenarios) if @scenarios

  @steps = Registry.all(:step)
  generate_full_list(@steps) if @steps

  @step_definitions = Registry.all(:stepdefinition)

  if @step_definitions
    generate_full_list(@step_definitions,"Step Definition") 
    @step_transformers = YARD::CodeObjects::StepTransformersObject.new(:root,"steptransformers")
    @step_definitions.each {|stepdef| @step_transformers << stepdef }
    serialize(@step_transformers)
  end


end

def generate_full_list(objects,friendly_name=nil)
  if !objects.empty?
    @items = objects
    @list_type = "#{objects.first.type.to_s}s"
    @list_title = "#{friendly_name || objects.first.type.to_s.capitalize} List"
    asset("#{objects.first.type}_list.html",erb(:full_list))
  else
    log.warn "Full List: Failed to create a list because the objects array is empty."
  end
end