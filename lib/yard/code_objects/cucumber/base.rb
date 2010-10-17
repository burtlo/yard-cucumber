
module YARD::CodeObjects::Cucumber

  module LocationHelper

    def line_number
      files.first.last
    end

    def file
      files.first.first if files && !files.empty?
    end

    def location
      "#{file}:#{line_number}"
    end

  end

  class Base < YARD::CodeObjects::Base
    include LocationHelper
    
    def path
      @value || super
    end

  end

  
  
end

