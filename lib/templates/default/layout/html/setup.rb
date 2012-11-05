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
  
  menus = [ "features", "tags" ]

  # load the yard-cucumber menus defined in the configuration file
  if YARD::Config.options["yard-cucumber"] and YARD::Config.options["yard-cucumber"]["menus"]
    menus = YARD::Config.options["yard-cucumber"]["menus"]
  end

  menus.map {|menu_name| yard_cucumber_menus[menu_name] }.compact + super
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
