def init
  super
  sections.push :steptransformers, [:stepdefinitions, :steptransforms], :undefined_steps
end


def stepdefinitions
  @item_title = "Step Definitions"
  @item_type = "step definition"
  @items = YARD::Registry.all(:stepdefinition)
  erb(:transformers)
end

def steptransforms
  @item_title = "Step Transforms"
  @item_type = "step transform"
  @items = YARD::Registry.all(:steptransform)
  erb(:transformers)
end

def undefined_steps
  @undefined_steps ||= Registry.all(:step).reject {|s| s.definition }
  erb(:undefined_steps)
end


def link_transformed_step(step)
  value = step.value
  
  if step.transformed?
    matches = step.value.match(step.definition.regex)
    
    if matches
      matches[1..-1].reverse.each_with_index do |match,index|
        next if match == nil
        transform = step.transforms.find {|transform| transform.regex.match(match) }
        
        value[matches.begin((matches.size - 1) - index)..(matches.end((matches.size - 1) - index) - 1)] = 
        transform ? "<a href='#{url_for(transform)}'>#{match}</a>" : "<span class='match'>#{match}</span>"
      end
    end
  end
  
  value
end