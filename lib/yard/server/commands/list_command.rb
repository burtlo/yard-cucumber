module YARD
  module Server
    module Commands
      
      class ListFeaturesCommand < ListCommand
        def type; :features end
        
        def items
          Registry.load_all
          run_verifier(Registry.all(:feature))
        end
      end
      
      class ListTagsCommand < ListCommand
        def type; :tags end
        
        def items
          Registry.load_all
          run_verifier(Registry.all(:tag).sort_by {|t| t.value.to_s })
        end
      end
      
    end
  end
end
