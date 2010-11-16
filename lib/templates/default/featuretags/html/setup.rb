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
  @features ||= Registry.all(:feature).sort {|x,y| x.value <=> y.value }
end

def scenarios
  @scenarios ||= Registry.all(:scenario).reject {|s| s.outline? || s.background? }.sort {|x,y| x.value <=> y.value }
end
