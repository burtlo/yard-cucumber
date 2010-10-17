def init
  super
  sections.push :steptransformers, [:stepdefinitions, :steptransforms]
end

def stepdefinitions
  
  object.children.find_all {|child| child.is_a?(YARD::CodeObjects::StepDefinitionObject)}.collect do |stepdefinition|
    @stepdefinition = stepdefinition
    erb(:stepdefinition)
  end.join("\n")
  
end

def steptransforms
  
end