include YARD::Templates::Helpers::HtmlHelper

def init
  super
  
  # Additional javascript that power the additional menus, collapsing, etc.
  asset("js/cucumber.js",file("js/cucumber.js",true))

  #
  # Generate pages for each feature, with the 'feature' template and then 
  # generate the page which is the full list of features
  #

  @features = Registry.all(:feature)

  if @features
    @features.each {|feature| serialize(feature) } 
    #generate_full_list @features.sort {|x,y| x.value.to_s <=> y.value.to_s }, :feature
  end
  
  #
  # Generate pages for each tag, with the 'tag' template and then generate the
  # page which is the full list of tags. Tags are ordered in descending order
  # by the size of how many scenarios that the affect
  #
  
  @tags = Registry.all(:tag)

  if @tags
    @tags.each {|tag| serialize(tag) }
    #generate_full_list @tags.sort {|x,y| y.all_scenarios.size <=> x.all_scenarios.size }, :tag
  end

  # Generates the requirements splash page with the 'requirements' template
  serialize(YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE)

  # Generates a page for step definitions and step transforms with the 'steptransformers' template
  serialize(YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE)
  
  # Generates the tags page with the 'featuretags' template
  serialize(YARD::CodeObjects::Cucumber::CUCUMBER_TAG_NAMESPACE)
  
  # Generate pages for each of the directories with features with the 'featuredirectory' template
  feature_directories = YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE.children.find_all {|child| child.is_a?(YARD::CodeObjects::Cucumber::FeatureDirectory) }
  serialize_feature_directories(feature_directories)

end


# Generate feature list
# @note this method is called automically by YARD based on the menus defined in the layout
def generate_feature_list
  @features = Registry.all(:feature)
  generate_full_list @features.sort {|x,y| x.value.to_s <=> y.value.to_s }, :feature
end

# Generate tag list
# @note this method is called automically by YARD based on the menus defined in the layout
def generate_tag_list
  @tags = Registry.all(:tag)
  generate_full_list @tags.sort {|x,y| y.all_scenarios.size <=> x.all_scenarios.size }, :tag
end

# Generate a step definition list
# @note this menu is not automatically added until yard configuration has this menu added
# See the layout template method that loads the menus
def generate_step_definition_list
  generate_full_list YARD::Registry.all(:stepdefinition), :stepdefinition
end

# Generate a step list
# @note this menu is not automatically added until yard configuration has this menu added
# See the layout template method that loads the menus
def generate_step_list
  generate_full_list YARD::Registry.all(:step), :step
end

# Helpler method to generate a full_list page of the specified objects with the 
# specified type.
def generate_full_list(objects,list_type,friendly_name=nil)
  @items = objects
  @list_type = "#{list_type}s"
  @list_title = "#{friendly_name || list_type.to_s.capitalize} List"
  @list_class = "class"
  asset("#{list_type}_list.html",erb(:full_list))
end

#
# The existing 'Class List' search field would normally contain the Cucumber
# Namespace object that has been added. Here we call the class_list method 
# that is contained in the YARD template and we remove the namespace. Returning
# it when we are done. 
#
def class_list(root = Registry.root)
  root.instance_eval { children.delete YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE } if root == Registry.root
  out = super(root)
  root.instance_eval { children << YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE } if root == Registry.root
  out
end

#
# Generate a page for each Feature Directory. This is called recursively to 
# ensure that all feature directories contained as children are rendered to
# pages.
#
def serialize_feature_directories(namespaces)
  namespaces.each do |namespace|
    Templates::Engine.with_serializer(namespace, options[:serializer]) do
      options[:object] = namespace
      T('layout').run(options)
    end
    serialize_feature_directories(namespace.children.find_all {|child| child.is_a?(YARD::CodeObjects::Cucumber::FeatureDirectory)})
  end
end

#
# Generate a link to the 'All Features' in the features_list.html
#
# When there are no feature directories or multiple top-level feature directories 
# then we want to link to the 'Requirements' page
#
# When there are is just one feature directory then we want to link to that directory
#
def all_features_link
  root_feature_directories = YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE.children.find_all {|child| child.is_a?(YARD::CodeObjects::Cucumber::FeatureDirectory)}

  if root_feature_directories.length == 0 || root_feature_directories.length > 1
    linkify YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE, "All Features"
  else
    linkify root_feature_directories.first, "All Features"
  end
end