
def init
  super
  log.debug "templates.default.fulldoc#init"
  
  #T('feature').run(options)
  
  
  asset("js/cucumber.js",file("js/cucumber.js",true))
  
  @features = Registry.all(:feature)
  
  @features.each do |feature|
    feature_serialize(feature)
  end
  
  @list_type = "features"
  @list_title = "Feature List"
  asset('feature_list.html', erb(:full_list))
end

def feature_serialize(object)
  options[:object] = object
  options[:css_data] = file('css/style.css', true) + "\n" + file('css/common.css', true)
  options[:js_data] = file('js/jquery.js', true) + file('js/app.js', true)
  
  log.info "Serializer Path #{options[:serializer].serialized_path(object)}"
  Templates::Engine.with_serializer(object.filename, options[:serializer]) do
    T('layout').run(options)
  end
end


def asset(path, content)
  options[:serializer].serialize(path, content) if options[:serializer]
end