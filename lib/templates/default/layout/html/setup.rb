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
def menu_lists
  [ { :type => 'feature', :title => 'Features', :search_title => 'Features' },
    { :type => 'tag', :title => 'Tags', :search_title => 'Tags' } ] + super
end