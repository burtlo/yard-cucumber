include Helpers::ModuleHelper

def init
  super
  log.info "Features: #{@features}"
  
  
  asset("js/cucumber.js",file("js/cucumber.js",true))
  
  @features = Registry.all(:feature)
  
  @list_type = "features"
  @list_title = "Feature List"
  asset('feature_list.html', erb(:full_list))
end


def asset(path, content)
  options[:serializer].serialize(path, content) if options[:serializer]
end