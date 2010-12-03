def init
  super
  sections.push :namespace
  @namespace = object
end

def namespace
  erb(:namespace)
end

def all_tags_by_letter
  hash = {}
  objects = tags
  objects = run_verifier(objects)
  objects.each {|o| (hash[o.value.to_s[1,1].upcase] ||= []) << o }
  hash
end

def tags
  @tags ||= Registry.all(:tag)
end

def features
  @features ||= Registry.all(:feature).sort {|x,y| x.value.to_s <=> y.value.to_s }
end

def scenarios
  @scenarios ||= features.collect {|f| f.scenarios.reject {|s| s.background? } }.flatten.sort {|x,y| x.value.to_s <=> y.value.to_s }
end

def tagify(tag)
  %{<span class="tag" href="#{url_for tag}">#{tag.value}</span>} 
end