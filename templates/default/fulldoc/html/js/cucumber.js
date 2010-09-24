function cucumberSearchFrameLinks() {
  $('#feature_list_link').click(function() {
    toggleSearchFrame(this, relpath + 'feature_list.html');
  });

}

$(cucumberSearchFrameLinks);