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
  Registry.all(:tag)
end
