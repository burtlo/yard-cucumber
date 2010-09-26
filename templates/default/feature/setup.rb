def init
  super
  log.info "templates.default.feature#init - PROCESSING FEATURE #{object}"
  
  sections.push :feature
  
  
  
  @feature = object
  
end
