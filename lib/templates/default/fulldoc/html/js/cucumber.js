function cucumberSearchFrameLinks() {
    $('#features_list_link').click(function() {
        toggleSearchFrame(this, relpath + 'feature_list.html');
    });
    $('#tags_list_link').click(function() {
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


function determineTagsUsedInFormula(tagString)  {

    tagString = tagString.replace(/^(\s+)|(\s+)$/,'').replace(/\s{2,}/,' ');

    var tagGroup = tagString.match(/@\w+(,@\w+)*/g);

    var returnTags = [];

    if (tagGroup) {
        tagGroup.forEach(function(tag, index, array) {
            //console.log("Tag Group: " + tag);
            var validTags = removeInvalidTags(tag)
            if (validTags != "") { returnTags.push(validTags); }
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