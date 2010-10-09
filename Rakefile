require 'rubygems'
require 'rake'
require 'hoe'
require 'yard'
require 'rspec/core/rake_task'

task :default => :yard

task :gendoc do
  #`yardoc -e lib/city.rb -p lib/yard/templates 'example/**/*.rb' 'example/**/*.feature'  --debug`
  `yardoc -e lib/city.rb -p lib/yard/templates 'example/**/*.rb' 'example/**/*.feature' --verbose`
end

yard_task = YARD::Rake::YardocTask.new
yard_task.files = FileList['example/**/*.feature','example/**/*.rb']
yard_task.options = %w{ -e lib/city.rb -p lib/yard/templates 'example/**/*.rb' 'examples/**/*.feature' --debug }

Hoe.spec 'cucumber-in-the-yard' do
  developer('email', 'franklin.webber@gmail')
end