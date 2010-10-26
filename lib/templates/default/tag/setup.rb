def init
  super
  @tag = object

  log.debug "\n\nTAGS: #{@tag.features.size} #{@tag.scenarios.size}"

  sections.push :tag, [:feature, :scenario]
end