def init
  super
  sections.push :stepdefinitions, :steptransforms, :undefined_steps
end


def stepdefinitions
  @item_title = "Step Definitions"
  @item_type = "step definition"
  @items = YARD::Registry.all(:stepdefinition)
  erb(:header) + erb(:transformers)
end

def steptransforms
  @item_title = "Step Transforms"
  @item_type = "step transform"
  @items = YARD::Registry.all(:steptransform)
  erb(:header) + erb(:transformers)
end

def undefined_steps
  @item_title = "Undefined Steps"
  @item_type = nil
  @undefined_steps ||= Registry.all(:step).reject {|s| s.definition || s.scenario.outline? }
  erb(:header) + erb(:undefined_steps)
end


def unique_steps(steps)
  uniq_steps = {}
  steps.each {|s| (uniq_steps[s.value.to_s] ||= []) << s }
  uniq_steps
end

def link_constants(definition)
  value = definition.literal_value.dup

  definition.constants_from_value(value).each do |name|
    constant = YARD::Registry.all(:constant).find{|c| c.name == name.to_sym }
    value.gsub!(/\b#{name}\b/,"<a href='#{url_for(constant)}'>#{name}</a>") if constant
  end

  value
end


def link_transformed_step(step)
  value = step.value.dup
  
  if step.definition
    matches = step.value.match(step.definition.regex)
    
    if matches
      matches[1..-1].reverse.each_with_index do |match,index|
        next if match == nil
        transform = step.transforms.find {|transform| transform.regex.match(match) }
        
        value[matches.begin((matches.size - 1) - index)..(matches.end((matches.size - 1) - index) - 1)] = transform ? "<a href='#{url_for(transform)}'>#{h(match)}</a>" : "<span class='match'>#{match}</span>"
      end
    end
  end
  
  value
end