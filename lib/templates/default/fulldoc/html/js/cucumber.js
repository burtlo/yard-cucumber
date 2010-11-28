function cucumberSearchFrameLinks() {
    $('#features_list_link').click(function() {
        toggleSearchFrame(this, relpath + 'feature_list.html');
    });
    $('#tags_list_link').click(function() {
        toggleSearchFrame(this, relpath + 'tag_list.html');
    });
}

$(cucumberSearchFrameLinks);


$(function() {

	//
    //  Feature Page - Scenarios 
    //
	$('.scenario div.title').click(function(eventObject) {
        if (typeof eventObject.currentTarget !== "undefined")  {
            toggleScenario( $($(eventObject.currentTarget).parent()) );
        }
    });

	//
	// Developer View
    // Click + Developer View = toggle the expansion of all tags, location, and comments
    //
	$('#view').click(function(eventObject) {
		
		if (typeof eventObject.currentTarget !== "undefined")  {
			var view = eventObject.currentTarget;
			
			if (view.innerHTML === '[More Detail]') {
				$('.developer').show(500);
				view.innerHTML = '[Less Detail]';
			} else {
				$('.developer').hide(500);
				// Already hidden elements with .developer sub-elements were not getting message
				$('.developer').each(function() { $(this).css('display','none'); });
				view.innerHTML = '[More Detail]';
			}
		}
    });

	//
	// Expand/Collapse All
	// 
    $('#expand').click(function(eventObject) {
	    
		if (typeof eventObject.currentTarget !== "undefined")  {
            if (eventObject.currentTarget.innerHTML === '[Expand All]') {
                eventObject.currentTarget.innerHTML = '[Collapse All]';
                $('div.scenario > div.details:hidden').each(function() {
					toggleScenario( $($(this).parent()) );
                });
            } else {
                eventObject.currentTarget.innerHTML = '[Expand All]';
                $('div.scenario > div.details:visible').each(function() {
					toggleScenario( $($(this).parent()) );
				});
            }
        }
    });

	// 
	// Scenario Outlines - Toggle Examples
	// 
	$('.outline table tr').click(function(eventObject) {
		
		if (typeof eventObject.currentTarget !== "undefined")  {
			var exampleRow = $(eventObject.currentTarget);
			var exampleClass = eventObject.currentTarget.className.match(/example\d+/)[0];
			var example = exampleRow.closest('div.details').find('.' + exampleClass);			
			
			var currentExample = null;
			
			$('.outline table tr').each(function() { $(this).removeClass('selected'); });
			
			if ( example[0].style.display == 'none' ) {
				currentExample = example[0];
				exampleRow.addClass('selected');
			} else {
				currentExample = exampleRow.closest('div.details').find('.steps')[0];
			}

			// hide everything 
			exampleRow.closest('div.details').find('.steps').each(function() { $(this).hide(); });
			
			// show the selected
			$(currentExample).show();
		}
	});


});
 

function toggleScenario(scenario) {
	
	var state = scenario.find(".attributes input[name='collapsed']")[0];
	
	if (state.value === 'true') {
		scenario.find("div.details").each(function() { $(this).show(500); });
		state.value = "false";
		scenario.find('a.toggle').each(function() { this.innerHTML = ' - '; });
		
	}  else {
		scenario.find("div.details").each(function() { $(this).hide(500); });
		state.value = "true";
		scenario.find('a.toggle').each(function() { this.innerHTML = ' + '; });
	}	
}


function updateTagFiltering(tagString) {
    var formulaTags = determineTagsUsedInFormula(tagString);
    displayExampleCommandLine(formulaTags);
    displayQualifyingFeaturesAndScenarios(formulaTags);
    hideEmptySections();
    fixSectionRowAlternations();
}

function determineTagsUsedInFormula(tagString)  {

    tagString = tagString.replace(/^(\s+)|(\s+)$/,'').replace(/\s{2,}/,' ');

    var tagGroup = tagString.match(/@\w+(,@\w+)*/g);

    var returnTags = [];

    if (tagGroup) {
        tagGroup.forEach(function(tag, index, array) {
            //console.log("Tag Group: " + tag);
            var validTags = removeInvalidTags(tag)
            if (validTags != "") {
                returnTags.push(validTags);
            }
        });
    }

    return returnTags;
}

function removeInvalidTags(tagGroup) {
    tagGroup.split(",").forEach(function(tag, index, array) {
        //console.log("Validating Tag: " + tag)
        if (tag_list.indexOf(tag) === -1) {
            //console.log("Removing Tag: " + tag);
            tagGroup = tagGroup.replace(new RegExp(',?' + tag + ',?'),"")
        }
    });

    return tagGroup;
}


function displayExampleCommandLine(tags) {
    $("#command_example")[0].innerHTML = "cucumber ";

    if (tags.length > 0)  {
        $("#command_example")[0].innerHTML += "--tags " + tags.join(" --tags ");
    }
}

function hideEmptySections() {
	
    ["feature","scenario"].forEach(function(section,index,sections) {
	
        if ( $("." + section + ":visible").length == 0 ) {
            $("#" + section + "s")[0].style.display = "none";
        } else {
            $("#" + section + "s")[0].style.display = "block";
        }
		
    });
}

function fixSectionRowAlternations() {

    ["feature","scenario"].forEach(function(section,index,sections) {
	
        $("." + section + ":visible")
        $("." + section + ":visible").each(function(index) {
            $(this).removeClass("r1 r2").addClass("r" + ((index % 2) + 1));
        });
		
    });
}

function displayQualifyingFeaturesAndScenarios(tags) {

    if (tags.length > 0) {

        $(".feature,.scenario").each(function(feature){
            this.style.display = "none";
        });

        var tagSelectors = generateCssSelectorFromTags(tags);

        tagSelectors.forEach(function(selector,selectorIndex,selectorArray) {
            $(".feature." + selector.replace(/@/g,"\\@").replace(/\s/,".") + ",.scenario." + selector.replace(/@/g,"\\@").replace(/\s/,".")).each(function(matchItem) {
                this.style.display = "block";
            });
        });

    } else {
        $(".feature,.scenario").each(function(feature){
            this.style.display = "block";
        });
    }

}

function generateCssSelectorFromTags(tagGroups) {

    var tagSelectors = [ "" ];

    tagGroups.forEach(function(tagGroup,index,array) {
        var newTagSelectors = [];

        tagSelectors.forEach(function(selector,selectorIndex,selectorArray) {
            tagGroup.split(",").forEach(function(tag,tagIndex,tagArray) {
                //console.log("selector: " + (selector + " " + tag).trim());
                newTagSelectors.push((selector + " " + tag).trim());
            });

        });

        tagSelectors = newTagSelectors;

    });


    return tagSelectors;
}