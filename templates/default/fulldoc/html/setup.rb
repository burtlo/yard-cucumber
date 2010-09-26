
def init
  super
  asset("js/cucumber.js",file("js/cucumber.js",true))

  # Because I don't parse correctly I have to find all my scenarios, steps, and tags
  @scenarios = []
  @tags = []
  @features = Registry.all(:feature)
  
  @features.each do |feature|
    serialize_object(feature)

    feature.tags.each do |tag|
      @tags << tag
      #serialize_object(tag)
    end

    feature.scenarios.each do |scenario|
      @scenarios << scenario
      
      scenario.tags.each do |tag|
        @tags << tag
      end
      
      serialize_object(scenario)
    end
  end
  
  @tags = find_unique_tags(@tags)
  
  @tags.each do |tag,tag_objects|
    serialize_object(tag_objects)
  end
  
  create_full_list(@tags.values,"Tag Usage")
  
  create_full_list(@features)
  create_full_list(@scenarios)
  
  
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





