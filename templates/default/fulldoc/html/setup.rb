
def init
  super
  asset("js/cucumber.js",file("js/cucumber.js",true))

  # Because I don't parse correctly I have to find all my scenarios, steps, and tags
  @scenarios = []
  @tags = []
  @features = Registry.all(:feature)
  
  @features.each do |feature|
    serialize_object(feature)

    feature.tags.each { |tag| @tags << tag }

    feature.scenarios.each do |scenario|
      @scenarios << scenario
      #serialize_object(scenario)
      scenario.tags.each { |tag| @tags << tag }
    end
  end
  
  @tags = find_unique_tags(@tags)
  
  @tags.each { |tag,tag_objects| serialize_object(tag_objects) }
  
  create_full_list(@tags.values,"Tag Usage")
  
  create_full_list(@features)
  create_full_list(@scenarios)
  
  
  @step_definitions = Registry.all(:stepdefinition)
  
  create_full_list(@step_definitions,"Step Definition")

  @steps = Registry.all(:step)
  
  create_full_list(@steps)

  # Find all CONSTANTS that are in the step definitions and in some way replace them for their match value
  
  @step_definitions.each do |stepdef|
    stepdef.constants = stepdef.value.scan(/\#\{([^\}]+)\}/).flatten.collect do |stepdef_constant| 
      object.constants.find {|constant| stepdef_constant.to_sym == constant.name }
    end
    
    log.debug "Step Definition Compare Value: #{stepdef.compare_value}"
  end
  
  

  # TODO: Find all the steps that would be matched by the step definitions. O(n^2)
  
  
end

def asset(path, content)
  options[:serializer].serialize(path, content) if options[:serializer]
end

def serialize_object(object)
  options[:object] = object
  Templates::Engine.with_serializer(object.filename, options[:serializer]) do
    T('layout').run(options)
  end
end

def create_full_list(objects,friendly_name=nil)
  @list_type = "#{objects.first.type.to_s}s"
  @list_title = "#{friendly_name || objects.first.type.to_s.capitalize} List"
  asset("#{objects.first.type}_list.html",erb(:full_list))
end

def find_unique_tags(tags)
  
  tags_hash = {}
  
  tags.each do |tag|
    tags_hash[tag.value] = YARD::Parser::Cucumber::TagUsage.new(:root,"tag_#{tag.value}") unless tags_hash[tag.value]
    tags_hash[tag.value.to_s] << tag
  end
  
  tags_hash
end





