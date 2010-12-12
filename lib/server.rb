require File.dirname(__FILE__) + "/city"
#
# For `yard server` utilize the templates and the static files at these locations
# before using the defaults 
#
YARD::Templates::Engine.register_template_path File.dirname(__FILE__) + '/templates'
YARD::Templates::Engine.register_template_path File.dirname(__FILE__) + '/docserver'

YARD::Server.register_static_path File.dirname(__FILE__) + "/templates/default/fulldoc/html"
YARD::Server.register_static_path File.dirname(__FILE__) + "/docserver/default/fulldoc/html"