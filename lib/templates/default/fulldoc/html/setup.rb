include YARD::Templates::Helpers::HtmlHelper

def init
  super

  # Additional javascript that power the additional menus, collapsing, etc.
  asset "js/cucumber.js", file("js/cucumber.js",true)

  serialize_object_type :feature

  serialize_object_type :tag

  # Generates the requirements splash page with the 'requirements' template
  serialize(YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE)

  # Generates a page for step definitions and step transforms with the 'steptransformers' template
  serialize(YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE)

  # Generates the tags page with the 'featuretags' template
  serialize(YARD::CodeObjects::Cucumber::CUCUMBER_TAG_NAMESPACE)

  serialize_feature_directories
end

#
# The top-level feature directories. This is affected by the directories that YARD is told to parse.
# All other features in sub-directories are contained under each of these top-level directories.
#
# @example Generating one feature directory
#
#     `yardoc 'example/**/*'`
#
# @example Generating two feature directories
#
#     `yardoc 'example/**/*' 'example2/**/*'`
#
# @return the feature directories at the root of the Cucumber Namespace.
#
def root_feature_directories
  @root_feature_directories ||= YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE.children.find_all {|child| child.is_a?(YARD::CodeObjects::Cucumber::FeatureDirectory)}
end

#
# Generate pages for the objects if there are objects of this type contained
# within the Registry.
#
def serialize_object_type(type)
  objects = Registry.all(type.to_sym)
  Array(objects).each {|object| serialize(object) }
end

#
# Generates pages for the feature directories found. Starting with all root-level feature
# directories and then recursively finding all child feature directories.
#
def serialize_feature_directories
  serialize_feature_directories_recursively(root_feature_directories)
  root_feature_directories.each {|directory| serialize(directory) }
end

#
# Generate a page for each Feature Directory. This is called recursively to
# ensure that all feature directories contained as children are rendered to
# pages.
#
def serialize_feature_directories_recursively(namespaces)
  namespaces.each do |namespace|
    Templates::Engine.with_serializer(namespace, options[:serializer]) do
      options[:object] = namespace
      T('layout').run(options)
    end
    serialize_feature_directories_recursively(namespace.children.find_all {|child| child.is_a?(YARD::CodeObjects::Cucumber::FeatureDirectory)})
  end
end


# Generate feature list
# @note this method is called automatically by YARD based on the menus defined in the layout
def generate_feature_list
  features = Registry.all(:feature)
  features_ordered_by_name = features.sort {|x,y| x.value.to_s <=> y.value.to_s }
  generate_full_list features_ordered_by_name, :features
end

# Generate tag list
# @note this method is called automatically by YARD based on the menus defined in the layout
def generate_tag_list
  tags = Registry.all(:tag)
  tags_ordered_by_use = Array(tags).sort {|x,y| y.all_scenarios.size <=> x.all_scenarios.size }

  generate_full_list tags_ordered_by_use, :tags
end

# Generate a step definition list
# @note this menu is not automatically added until yard configuration has this menu added
# See the layout template method that loads the menus
def generate_stepdefinition_list
  generate_full_list YARD::Registry.all(:stepdefinition), :stepdefinitions,
    :list_title => "Step Definitions List"
end

# Generate a step list
# @note this menu is not automatically added until yard configuration has this menu added
# See the layout template method that loads the menus
def generate_step_list
  generate_full_list YARD::Registry.all(:step), :steps
end

# Generate feature list
# @note this menu is not automatically added until yard configuration has this menu added
# See the layout template method that loads the menus
def generate_featuredirectories_list
  directories_ordered_by_name = root_feature_directories.sort {|x,y| x.value.to_s <=> y.value.to_s }
  generate_full_list directories_ordered_by_name, :featuredirectories, 
    :list_title => "Features by Directory",
    :list_filename => "featuredirectories_list.html"
end


# Helpler method to generate a full_list page of the specified objects with the
# specified type.
def generate_full_list(objects,type,options = {})
  defaults = { :list_title => "#{type.to_s.capitalize} List",
    :css_class => "class",
    :list_filename => "#{type.to_s.gsub(/s$/,'')}_list.html" }

  options = defaults.merge(options)

  @items = objects
  @list_type = type
  @list_title = options[:list_title]
  @list_class = options[:css_class]
  asset options[:list_filename], erb(:full_list)
end

#
# @note This method overrides YARD's default template class_list method.
#
# The existing YARD 'Class List' search field contains all the YARD namespace objects.
# We, however, do not want the Cucumber Namespace YARD Object (which holds the features,
# tags, etc.) as it is a meta-object.
#
# This method removes the namespace from the root node, generates the class list,
# and then adds it back into the root node.
#
def class_list(root = Registry.root)
  return super unless root == Registry.root

  cucumber_namespace = YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE
  root.instance_eval { children.delete cucumber_namespace }
  out = super(root)
  root.instance_eval { children.push cucumber_namespace }
  out
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
  if root_feature_directories.length == 0 || root_feature_directories.length > 1
    linkify YARD::CodeObjects::Cucumber::CUCUMBER_NAMESPACE, "All Features"
  else
    linkify root_feature_directories.first, "All Features"
  end
end

def directory_node(directory)
  @directory = directory
  erb(:directories)
end
