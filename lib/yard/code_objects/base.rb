
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
    
    # def sep ; '/' ; end
    
    # def path
    #       if parent && !parent.root?
    #         [ "Cucumber$", name.to_s ].join(sep)
    #       else
    #         name.to_s
    #       end
    #     end

  end

  
  
end

