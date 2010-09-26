
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
      serialize_object(tag)
    end

    feature.scenarios.each do |scenario|
      @scenarios << scenario
      serialize_object(scenario)
    end
  end
  
  create_full_list(@features)
  create_full_list(@scenarios)
  create_full_list(@tags)
end

def serialize_object(object)
  options[:object] = object
  Templates::Engine.with_serializer(object.filename, options[:serializer]) do
    T('layout').run(options)
  end
end

def create_full_list(objects)
  #if objects
    @list_type = "#{objects.first.type.to_s.capitalize}s"
    @list_title = "#{objects.first.type.to_s.capitalize} List"
    asset("#{objects.first.type}_list.html",erb(:full_list))
  #end
end


def asset(path, content)
  options[:serializer].serialize(path, content) if options[:serializer]
end