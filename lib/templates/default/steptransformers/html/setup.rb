def init
  super
  sections.push :index, :stepdefinitions, :steptransforms, :undefinedsteps
end

def step_definitions
  @step_definitions ||= begin
    YARD::Registry.all(:stepdefinition).sort_by {|definition| definition.steps.length * -1 }
  end
end

def step_transforms
  @step_transforms ||= begin
    YARD::Registry.all(:steptransform).sort_by {|definition| definition.steps.length * -1 }
  end
end

def undefined_steps
  @undefined_steps ||= begin
    unique_steps(Registry.all(:step).reject {|s| s.definition || s.scenario.outline? }).sort_by{|steps| steps.last.length * -1 }
  end
end

def stepdefinitions
  @item_title = "Step Definitions"  
  @item_anchor_name = "step_definitions"
  @item_type = "step definition"
  @items = step_definitions
  erb(:header) + erb(:transformers)
end

def steptransforms
  @item_title = "Step Transforms"
  @item_anchor_name = "step_transforms"
  @item_type = "step transform"
  @items = step_transforms
  erb(:header) + erb(:transformers)
end

def undefinedsteps
  @item_title = "Undefined Steps"  
  @item_anchor_name = "undefined_steps"
  @item_type = nil
  @items = undefined_steps
  erb(:header) + erb(:undefinedsteps)
end


def unique_steps(steps)
  uniq_steps = {}
  steps.each {|s| (uniq_steps[s.value.to_s] ||= []) << s }
  uniq_steps
end

def display_comments_for(item)
  begin
    T('docstring').run(options.dup.merge({:object => item}))
  rescue
    log.warn %{An error occurred while attempting to render the comments for: #{item.location} }
    return ""
  end
  
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