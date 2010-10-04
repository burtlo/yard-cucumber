require 'rubygems'
require 'rake'
require 'hoe'
require 'yard'
require 'rspec/core/rake_task'

task :default => :yard

task :gendoc do
  `yardoc -e lib/city.rb -p templates 'example/**/*.feature' 'example/**/*.rb' --debug`
end

yard_task = YARD::Rake::YardocTask.new
yard_task.files = FileList['example/**/*.feature','example/**/*.rb']
yard_task.options = %w{ -e lib/city.rb -p templates 'examples/**/*.feature' 'example/**/*.rb' --debug }

Hoe.spec 'cucumber-in-the-yard' do
  developer('email', 'franklin.webber@gmail')
end


#
# Hoe spec operation did not allow me to insert my spec options, so I remove theirs and replace it with mine
#

Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end
