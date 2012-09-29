def init
  super
  sections.push :directory
  @directory = object
end

def markdown(text)
  htmlify(text,:markdown) rescue h(text)
end

def htmlify_with_newlines(text)
  text.split("\n").collect {|c| h(c).gsub(/\s/,'&nbsp;') }.join("<br/>")
end

def directories
  @directories ||= @directory.subdirectories
end

def features
  @features ||= @directory.features + directories.collect {|d| d.features }.flatten
end

def scenarios
  @scenarios ||= features.collect {|feature| feature.scenarios }.flatten
end

def tags
  @tags ||= (features.collect{|feature| feature.tags } + scenarios.collect {|scenario| scenario.tags }).flatten.uniq.sort_by {|l| l.value.to_s }
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
