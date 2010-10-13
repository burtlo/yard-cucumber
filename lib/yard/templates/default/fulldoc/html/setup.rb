include YARD::Templates::Helpers::HtmlHelper

def init
  super
  asset("js/cucumber.js",file("js/cucumber.js",true))

  @features = Registry.all(:feature)

  if @features
    @features.each {|feature| serialize(feature) } 
    create_full_list(@features)
  end

  @tags = Registry.all(:tag)
  
  if @tags
    @tags = find_unique_tags(@tags)
    @tags.each { |tag,tag_objects| serialize(tag_objects) }
    @tagusage = @tags.values.sort {|x,y| y.total_scenario_count <=> x.total_scenario_count }
    create_full_list(@tagusage,"Tag Usage") if @tagusage
  end

  @scenarios = Registry.all(:scenario)
  create_full_list(@scenarios) if @scenarios

  @steps = Registry.all(:step)
  create_full_list(@steps) if @steps

  @step_definitions = Registry.all(:stepdefinition)

  if @step_definitions
    create_full_list(@step_definitions,"Step Definition") 
    @step_transformers = YARD::CodeObjects::StepTransformersObject.new(:root,"steptransformers")
    @step_definitions.each {|stepdef| @step_transformers << stepdef }
    serialize(@step_transformers)
  end


end


def create_full_list(objects,friendly_name=nil)
  if !objects.empty?
    @list_type = "#{objects.first.type.to_s}s"
    @list_title = "#{friendly_name || objects.first.type.to_s.capitalize} List"
    asset("#{objects.first.type}_list.html",erb(:full_list))
  else
    log.warn "Full List: Failed to create a list because the objects array is empty."
  end
end

def find_unique_tags(tags)

  tags_hash = {}

  tags.each do |tag|
    tags_hash[tag.value] = YARD::CodeObjects::Cucumber::TagUsage.new(:root,"tag_#{tag.value}"){|t| t.value = tag.value } unless tags_hash[tag.value]
    tags_hash[tag.value.to_s] << tag
  end

  tags_hash
end

