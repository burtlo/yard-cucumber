require 'rubygems'
require 'rake'

task :default => :gendoc

# No care in the world at the moment that this should require the YARD gem
task :gendoc do
  `yardoc -e yard_extensions.rb -p templates'example/**/*.feature' 'example/**/*.rb'`
end