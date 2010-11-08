function cucumberSearchFrameLinks() {
	$('#feature_list_link').click(function() {
		toggleSearchFrame(this, relpath + 'feature_list.html');
	});
	$('#tagusage_list_link').click(function() {
		toggleSearchFrame(this, relpath + 'tag_list.html');
	});
}

$(cucumberSearchFrameLinks);



function toggleScenarioExample(id,example) {

	var element = $("#" + id + "Example" + example + "Steps")[0];

	$('#' + id + ' tr').each(function(index) {
		this.style.backgroundColor = (index % 2 == 0 ? '#FFFFFF' : '#F0F6F9' );
	});

	if (element.style.display != 'none') {
		element = $("#" + id + "Steps")[0];
	} else {
		$('#' + id + ' .outline * tr')[example].style.backgroundColor = '#FFCC80';
	}

	$('#' + id + ' .steps').each(function(index) {
		this.style.display = 'none';
	});

	element.style.display = 'block';

}

function determine_tags_used_in_formula(tag_string)  {
	//$("#tag_debug")[0].innerHTML = "";
	
	tag_string = tag_string.replace(/^(\s+)|(\s+)$/,'').replace(/\s{2,}/,' ');

	var tags = tag_string.match(/@\w+/g);

	var return_tags = [];

	if (tags != null) {
		tags.forEach(function(tag, index, array) {
			//$("#tag_debug")[0].innerHTML += tag + " ";
			if (tag_list.indexOf(tag) != -1) { return_tags.push(tag); }
		});
	}

	return return_tags;
}


function display_example_command_line(tags) {
	$("#command_example")[0].innerHTML = "cucumber ";

	if (tags.length > 0)  {
		$("#command_example")[0].innerHTML += "--tags " + tags.join(" --tags ");
	}
}

function display_qualifying_features_and_scenarios(tags) {
	//$("#tag_debug")[0].innerHTML = "";

	if (tags.length > 0) {
		
		$(".feature,.scenario").each(function(feature){
			this.style.display = "none";
		});

		$(".feature.\\" + tags.join(".\\") + ",.scenario.\\" + tags.join(".\\")).each(function(feature) {
			//$("#tag_debug")[0].innerHTML += feature + " " + this;
			this.style.display = "block";
		});

		
	}  else {
		$(".feature,.scenario").each(function(feature){
			this.style.display = "block";
		});
	}

}