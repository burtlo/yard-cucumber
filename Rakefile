require 'rubygems'
require 'rake'
require 'hoe'
require 'yard'
require 'rspec/core/rake_task'

task :default => :yard

task :gendoc do
  `yardoc -e lib/city.rb -p lib/yard/templates 'example/**/*.feature' 'example/**/*.rb' --debug`
end

yard_task = YARD::Rake::YardocTask.new
yard_task.files = FileList['example/**/*.feature','example/**/*.rb']
yard_task.options = %w{ -e lib/city.rb -p lib/yard/templates 'examples/**/*.feature' 'example/**/*.rb' --debug }

Hoe.spec 'cucumber-in-the-yard' do
  developer('email', 'franklin.webber@gmail')
end