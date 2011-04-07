def init
  super
end

def javascript_files
  existing_js = super rescue [ 'js/jquery.js','js/app.js' ]
  existing_js + [ 'js/cucumber.js' ]
end

def search_fields
  existing_fields = super rescue [ [ 'class_list_link', 'Class List' ],[ 'method_list_link', 'Method List' ],[ 'file_list_link', 'File List' ] ] 
  existing_fields + [ [ 'features_list_link', 'Features' ],[ 'tags_list_link', 'Tags' ] ]
end