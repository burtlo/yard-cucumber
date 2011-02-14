module YARD
  module Server

    #
    # The YARD::Server::Router needs the following modification,
    # so that it will provide routing for the features and tags commands
    # to their appropriate definitions
    #
    Router.class_eval do

      alias_method :core_route_list, :route_list

      #
      # Provide the full list of features and tags
      #
      def route_list(library, paths)
          
        if paths && !paths.empty? && paths.first =~ /^(?:features|tags)$/
          case paths.shift
          when "features"; cmd = Commands::ListFeaturesCommand
          when "tags"; cmd = Commands::ListTagsCommand
          end
          cmd.new(final_options(library, paths)).call(request)
        else
          core_route_list(library,paths)
        end
        
      end

    end
  end
end