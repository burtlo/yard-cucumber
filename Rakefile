require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require 'spec/expectations'
require 'yard'

task :default => :yard

task :gendoc do
  `yardoc -e yard_extensions.rb -p templates 'example/**/*.feature' 'example/**/*.rb' --debug`
end

yard_task = YARD::Rake::YardocTask.new
yard_task.files = FileList['example/**/*.feature','example/**/*.rb']
yard_task.options = %w{ -e yard_extensions.rb -p templates 'examples/**/*.feature' 'example/**/*.rb' --debug }

rspec_task = Spec::Rake::SpecTask.new
rspec_task.spec_files = FileList['yard_extensions.rb']
rspec_task.spec_opts  = ['-c','-f specdoc']