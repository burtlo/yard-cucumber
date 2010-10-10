require 'rake'
require 'echoe'
require 'yard'
require 'rspec/core/rake_task'

task :default => :yard

task :gendoc do
  `yardoc -e lib/city.rb -p lib/yard/templates 'example/**/*.rb' 'example/**/*.feature' --quiet --verbose`
end

yard_task = YARD::Rake::YardocTask.new
yard_task.files = FileList['example/**/*.feature','example/**/*.rb']
yard_task.options = %w{ -e lib/city.rb -p lib/yard/templates 'example/**/*.rb' 'examples/**/*.feature' --debug }


Echoe.new('cucumber-in-the-yard', '1.0') do |g|
  g.author = "Frank;lin Webber"
  g.email = "franklin.webber@gmail.com"
  g.url = "http://github.com/burtlo/Cucumber-In-The-Yard"
  g.description = %{ 
    Cucumber-In-The-Yard is a YARD extension that processes Cucumber Features, Scenarios, Steps,
    Step Definitions, Transforms, and Tags and provides a documentation interface that allows you
    easily view and investigate the test suite.  This tools hopes to bridge the gap of being able
    to provide your feature descriptions to your Product Owners and Stakeholders.  }
  g.ignore_pattern = FileList["{doc,autotest}/**/*"].to_a
  g.runtime_dependencies = [ "cucumber >=0.7.5", "yard >=0.6.1" ]
end
