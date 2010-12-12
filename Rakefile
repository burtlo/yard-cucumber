require 'rake'

task :default => :gendoc

task :clean do
  `rm -rf doc`
  `rm -rf .yardoc`
end

task :gendoc => :clean do
  `yardoc -e ./lib/city.rb -p ./lib/templates 'example/**/*' --debug`
end

task :old => :clean do
  `/usr/bin/yardoc -e lib/city.rb -p lib/templates 'example/**/*' --debug`
end

task :server do
  `yard server -e ./lib/server.rb --debug`
end