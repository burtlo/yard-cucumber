function cucumberSearchFrameLinks() {
	$('#feature_list_link').click(function() {
		toggleSearchFrame(this, relpath + 'feature_list.html');
	});  
	$('#tagusage_list_link').click(function() {
		toggleSearchFrame(this, relpath + 'tag_list.html');
	});  
}

$(cucumberSearchFrameLinks);