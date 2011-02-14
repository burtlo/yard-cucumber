module YARD::Parser

  class SourceParser
    class << self

      #
      # Following the conventions of ordering as Cucumber performs it
      #  
      #  environment files - 'directory/support/env.rb,env_*.rb'
      #  support files     - 'directory/support/*.rb' (but not env prefixed)
      #  directory files   - 'directory/*.rb'
      #  
      #  feature files     - 'directory/*.feature'
      #
      def order_by_cucumber_standards(*files)
        
        non_feature_files = files.reject {|x| x =~ /^.+\.feature$/}
        feature_files = files.find_all {|x| x =~ /^.+\.feature$/ }
        
        support_files = non_feature_files.find_all {|file| file =~ /support\/.+\.rb$/ }
        other_files = non_feature_files - support_files
        
        environment_files = support_files.find_all {|file| file =~ /support\/env.*\.rb$/ }
        environment_files.sort_by {|x| x.length if x }
        
        support_files = support_files - environment_files
        
        environment_files + support_files + other_files + feature_files
      end

      #
      # Overriding the parse_in_order method was necessary so that step definitions
      # match to steps utilizing the load ordering that is used by Cucumber.
      #
      def parse_in_order(*files)
        
        files = order_by_cucumber_standards(*files)
        
        while file = files.shift
          begin
            if file.is_a?(Array) && file.last.is_a?(Continuation)
              log.debug("Re-processing #{file.first}")
              file.last.call
            elsif file.is_a?(String)
              log.debug("Processing #{file}...")
              new(parser_type, true).parse(file)
            end
          rescue LoadOrderError => e
            # Out of order file. Push the context to the end and we'll call it
            files.push([file, e.message])
          end
        end
      end
      
    end
  end
  
end