module YARD::Rake
  
  class CitydocTask < YardocTask
  
    def initialize(name = :yard)
      super
      self.options += [ "-e", "#{ File.dirname(__FILE__)}/../../city.rb", "-p", "#{File.dirname(__FILE__)}/../templates" ]
    end
    
  end
  
end