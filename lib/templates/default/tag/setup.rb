def init
  super
  @tag = object

  sections.push :tag
  sections.push :feature unless @tag.features.empty?
  sections.push :scenario unless @tag.scenarios.empty?
end

def all_features_by_letter
  hash = {}
  @tag.features.each {|o| (hash[o.value.to_s[0,1].upcase] ||= []) << o }
  hash
end

def all_scenarios_by_letter
  hash = {}
  @tag.scenarios.each {|o| (hash[o.value.to_s[0,1].upcase] ||= []) << o }
  hash
end