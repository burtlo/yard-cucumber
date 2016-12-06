def init
  super
end

#
# Append yard-cucumber stylesheet to yard core stylesheets
#
def stylesheets
  super + %w(css/cucumber.css)
end

#
# Append yard-cucumber javascript to yard core javascripts
#
def javascripts
  super + %w(js/cucumber.js)
end

#
# Append yard-cucumber specific menus 'features' and 'tags'
#
# 'features' and 'tags' are enabled by default.
#
# 'step definitions' and 'steps' may be enabled by setting up a value in
# yard configuration file '~/.yard/config'
#
# @example `~/.yard.config`
#
#     yard-cucumber:
#       menus: [ 'features', 'directories', 'tags', 'step definitions', 'steps' ]
#
def menu_lists
  current_menu_lists.map {|menu_name| yard_cucumber_menus[menu_name] }.compact + super
end

#
# By default we want to display the 'features' and 'tags' menu but we will allow
# the YARD configuration to override that functionality.
#
def current_menu_lists
  @current_menu_lists ||= begin
    menus = [ "features", "tags" ]

    if YARD::Config.options["yard-cucumber"] and YARD::Config.options["yard-cucumber"]["menus"]
      menus = YARD::Config.options["yard-cucumber"]["menus"]
    end

    menus
  end
end

#
# When a menu is specified in the yard configuration file, this hash contains
# the details about the menu necessary for it to be displayed.
#
# @see #menu_lists
#
def yard_cucumber_menus
  { "features" => { :type => 'feature', :title => 'Features', :search_title => 'Features' },
    "directories" => { :type => 'featuredirectories', :title => 'Features by Directory', :search_title => 'Features by Directory' },
    "tags" => { :type => 'tag', :title => 'Tags', :search_title => 'Tags' },
    "step definitions" => { :type => 'stepdefinition', :title => 'Step Definitions', :search_title => 'Step Defs' },
    "steps" => { :type => 'step', :title => 'Steps', :search_title => 'Steps' } }
end

#
# @note This method overrides YARD's default layout template's layout method.
#
# The existing YARD layout method generates the url for the nav menu on the left
# side. For YARD-Cucumber objects this will default to the class_list.html.
# which is not what we want for features, tags, etc.
#
# So we override this method and put in some additional logic to figure out the
# correct list to appear in the search. This can be particularly tricky because
#
# This method removes the namespace from the root node, generates the class list,
# and then adds it back into the root node.
#
def layout
  @nav_url = url_for_list(!@file || options.index ? 'class' : 'file')


  if is_yard_cucumber_object?(object)
    @nav_url = rewrite_nav_url(@nav_url)
  end

  if !object || object.is_a?(String)
    @path = nil
  elsif @file
    @path = @file.path
  elsif !object.is_a?(YARD::CodeObjects::NamespaceObject)
    @path = object.parent.path
  else
    @path = object.path
  end

  erb(:layout)
end

#
# Determine if the object happens to be a CodeObject defined in this gem.
#
# @note quite a few of the classes/modules defined here are not object that we
#   would never want to display but it's alright if we match on them.
#
# @return [Boolean] true if the object's class name is one of the CodeObjects
#
def is_yard_cucumber_object?(object)
  YARD::CodeObjects::Cucumber.constants.any? {|constant| object.class.name == "YARD::CodeObjects::Cucumber::#{constant}" }
end

#
# The re-write rules will only change the nav link to a new menu if it is a
# a Cucumber CodeObject that we care about and that we have also generated a
# menu for that item.
#
def rewrite_nav_url(nav_url)
  if object.is_a?(YARD::CodeObjects::Cucumber::Feature) && current_menu_lists.include?('features')
    nav_url.gsub('class_list.html','feature_list.html')
  elsif object.is_a?(YARD::CodeObjects::Cucumber::FeatureDirectory) && current_menu_lists.include?('directories')
    nav_url.gsub('class_list.html','featuredirectories_list.html')
  elsif object.is_a?(YARD::CodeObjects::Cucumber::Tag) && current_menu_lists.include?('tags')
    nav_url.gsub('class_list.html','tag_list.html')
  elsif object.is_a?(YARD::CodeObjects::Cucumber::Step) && current_menu_lists.include?('steps')
    nav_url.gsub('class_list.html','step_list.html')
  elsif object.is_a?(YARD::CodeObjects::Cucumber::StepTransformersObject) && current_menu_lists.include?('step definitions')
    nav_url.gsub('class_list.html','stepdefinition_list.html')
  else
    nav_url
  end
end
