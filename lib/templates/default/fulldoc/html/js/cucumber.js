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
