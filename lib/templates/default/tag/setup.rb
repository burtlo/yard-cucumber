def init
  super
  @tag = object

  sections.push :tag, [:feature, :scenario]
end