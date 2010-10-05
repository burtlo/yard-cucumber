function cucumberSearchFrameLinks() {
	$('#feature_list_link').click(function() {
		toggleSearchFrame(this, relpath + 'feature_list.html');
	});  
	$('#tagusage_list_link').click(function() {
		toggleSearchFrame(this, relpath + 'tagusage_list.html');
	});  
	$('#scenario_list_link').click(function() {
		toggleSearchFrame(this, relpath + 'scenario_list.html');
	});
}

$(cucumberSearchFrameLinks);