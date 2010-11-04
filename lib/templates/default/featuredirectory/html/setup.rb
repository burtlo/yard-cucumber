def init
  super
  sections.push :directory
  @directory = object
end

def directory
  @objects_by_letter = all_types_by_letter(YARD::CodeObjects::Cucumber::Feature)
  @directories_by_letter = @directory.children.find_all {|child| child.is_a?(YARD::CodeObjects::Cucumber::FeatureDirectory) }.sort_by {|dir| dir.name.to_s }
  erb(:directory)
end

def all_types_by_letter(type)
  hash = {}
  objects = @directory.children.find_all {|child| child.is_a?(type) }
  objects = run_verifier(objects)
  objects.each {|o| (hash[o.value.to_s[0,1].upcase] ||= []) << o }
  hash
end

def features
  @directory.children.find_all{|child| child.is_a?(YARD::CodeObjects::Cucumber::Feature)}
end

def scenarios
  features.collect {|feature| feature.scenarios }.flatten
end

def steps
  scenarios.collect {|scenario| scenario.steps }.flatten
end

def tags
  (features.collect{|feature| feature.tags } + scenarios.collect {|scenario| scenario.tags }).flatten.uniq
end

