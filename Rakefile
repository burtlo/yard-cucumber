require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require 'spec/expectations'
require 'yard'

task :default => :gendoc

# No care in the world at the moment that this should require the YARD gem
task :gendoc do
  `yardoc -e yard_extensions.rb -p templates 'example/**/*.feature' 'example/**/*.rb' --debug`
end

# Prepare the basic options for the RSpec tasks
rspec_task = Spec::Rake::SpecTask.new
rspec_task.spec_files = FileList['yard_extensions.rb']
rspec_task.spec_opts  = ['-c','-f specdoc']