include T('default/fulldoc/html')

def init
  case @list_type.to_sym
  when :features; @list_title = "Features"
  when :tags; @list_title = "Tags"
  when :class; @list_title = "Class List"
  when :methods; @list_title = "Method List"
  when :files; @list_title = "File List"
  end
  sections :full_list
end