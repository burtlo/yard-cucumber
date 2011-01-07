def init
  super
  sections.push :requirements
  @namespace = object

end

def features
  @features ||= Registry.all(:feature)
end

def tags
  @tags ||= Registry.all(:tag).sort_by {|l,o| l.value.to_s }
end

def feature_directories
  @feature_directories ||= YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE.children.find_all {|child| child.is_a?(YARD::CodeObjects::Cucumber::FeatureDirectory)}
end

def feature_subdirectories
  @feature_subdirectories ||= Registry.all(:featuredirectory) - feature_directories
end

def alpha_table(objects)
  @elements = Hash.new

  objects = run_verifier(objects)
  objects.each {|o| (@elements[o.value.to_s[0,1].upcase] ||= []) << o }
  @elements.values.each {|v| v.sort! {|a,b| b.value.to_s <=> a.value.to_s } }
  @elements = @elements.sort_by {|l,o| l.to_s }

  @elements.each {|letter,objects| objects.sort! {|a,b| b.value.to_s <=> a.value.to_s }}
  erb(:alpha_table)
end
