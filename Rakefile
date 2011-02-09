require 'rake'

task :default => :yardoc

task :clean do
  `rm -rf doc`
  `rm -rf .yardoc`
end

task :gendoc => :clean do
  `yardoc -e ./lib/city.rb -p ./lib/templates 'example/**/*' --debug`
end

task :gem do
  `gem build city.gemspec`
  `gem install --local yard-cucumber-2.0.0.gem`
end