require 'rake'

task :default => :yardoc

task :clean do
  `rm -rf doc`
  `rm -rf .yardoc`
end

task :yardoc do
  `yardoc 'example/**/*.rb' 'example/**/*.feature' --debug`
end

task :gendoc => :clean do
  `yardoc -e ./lib/city.rb -p ./lib/templates 'example/**/*' --debug`
end

task :server do
  `yard server -e ./lib/server.rb --debug`
end