def init
  super
  sections.push :namespace
  @namespace = object

end

def namespace
  @directories = Registry.all(:featuredirectory)
  erb(:namespace)
end

def all_features_by_letter
  hash = {}
  objects = features
  objects = run_verifier(objects)
  objects.each {|o| (hash[o.value.to_s[0,1].upcase] ||= []) << o }
  hash
end

def features
  Registry.all(:feature)
end

def scenarios
  Registry.all(:scenario)
end

def steps
  Registry.all(:step)
end

def tags
  Registry.all(:tag)
end
