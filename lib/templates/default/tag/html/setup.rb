def init
  super
  @tag = object

  sections.push :tag
end

def features
  @tag.features
end

def scenarios
  @tag.scenarios
end


def alpha_table(objects)
  @elements = Hash.new

  objects = run_verifier(objects)
  objects.each {|o| (@elements[o.value.to_s[0,1].upcase] ||= []) << o }
  @elements.values.each {|v| v.sort! {|a,b| b.value.to_s <=> a.value.to_s } }
  @elements = @elements.sort_by {|l,o| l.to_s }

  @elements.each {|letter,objects| objects.sort! {|a,b| b.value.to_s <=> a.value.to_s }}
  erb(:alpha_table)
end