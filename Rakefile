require 'rake'

task :default => :gendoc

task :gendoc do
  `rm -rf doc`
  `rm -rf .yardoc`
  `yardoc -e lib/city.rb -p lib/templates 'example/**/*.*' --debug`
end

task :server do
  `yard server -e lib/city.rb`
end
