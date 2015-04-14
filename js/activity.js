/**
 * Activity-related functions
 */
///// ACTIVITY TYPE ///////////////////////////////////////////////////////////

var ActivityType = Backbone.Model.extend({
    getIconPath: function() {
        return "img/" + this.icon + ".png"
    }
});

var ALL_ACTIVITY_TYPES = {
    "unspecified":  new ActivityType({displayName:"Unspecified",icon: "who-knows"}),

    "running":      new ActivityType({displayName: "Running",   icon: "running"}),
    "baseball":     new ActivityType({displayName: "Baseball",  icon: "baseball"}),
    "basketball":   new ActivityType({displayName: "Basketball",icon: "basketball"}),
    "swimming":     new ActivityType({displayName: "Swimming",  icon: "swimming"}),
    "curling":      new ActivityType({displayName: "Curling",   icon: "curling"}),
    // TODO add more if desired
}

    ///// ACTIVITY INFO POPUP /////////////////////////////////////////////////////
function setupActivity(){
    $('#durationInput').spinner();

    // make the text field be an autocomplete text (this plays poorly
    // with the dropdown, but would be preferable)
    // $('#activityTypeInput').autocomplete({
    //     source: Object.keys(ALL_ACTIVITY_TYPES),
    //     minLength: 0,
    //     select: function(event, ui) {
    //         console.log("selected item: " + ui.item);
    //         return true;
    //     }
    // });

    // make the activity type menu // TODO render via Marionette
    // var activityTypesMenu = $('#activityTypeMenu')
    // $.each(ALL_ACTIVITY_TYPES, function(i) {
    //     var li = $('<li/>')
    //         .addClass('ui-menu-item')
    //         .attr('role', 'menuitem')
    //         .appendTo(activityTypesMenu);
    //     var itm = $('<a/>')
    //         .addClass('ui-all')
    //         .text(ALL_ACTIVITY_TYPES[i].get('displayName'))
    //         .appendTo(li);
    // });
    // $('#activityTypeMenu').menu({
    //     select: function(event, ui) {
    //         alert(ui.item.text());
    //     }
    // });

    // actually, let's go with a select menu
    var activityTypeSelect = $('#activityTypeSelect');
    var options = '';
    $.each(ALL_ACTIVITY_TYPES, function(i) {
        typ = ALL_ACTIVITY_TYPES[i].get('displayName');
        options += '<option value="'+ typ + '" class="activityType">' + typ + '</option>';
    });
    activityTypeSelect.append(options);

    $("#submitActivityInfo").click(function(e) {
        duration = $("#durationInput").val();
        typ = $("#activityTypeSelect").val();
        console.log(duration);
        console.log(typ);
    });
    // activityTypeSelect.selectmenu({  // selectmenu breaks with dropdown...
    //     select: function(event, ui) {
    //         alert(ui.item.value);
    //    }
    // });

    // don't close the popup when clicked
    $('.dropdown-menu').click(function(e) {
          e.stopPropagation();
    });

    // force durations to be numeric
    // adapted from http://stackoverflow.com/a/20186188/1153180
    $(document).on('keyup', '.numeric-only', function(event) {
        var v = this.value;
        if($.isNumeric(v) === false || v < 0) {
            this.value = this.value.slice(0,-1); // remove last char entered
        }
    });

    $('#submitActivityInfo').click(function() {
        hideActivityInfo();
    });

    // hide activity info upon click outside
    // http://stackoverflow.com/a/7385673/1153180
    $(document).mouseup(function(e) {
        var container = $("#activityInfoView");
        if (!container.is(e.target) // if the target of the click isn't the container...
            && container.has(e.target).length === 0  // ... nor a descendant of the container
            && container.css('visibility') === 'visible') // and currently showing
        {
            container.css('visibility', 'hidden');
        }
    });
}

function showActivityInfoAtPosition(x, y) {
    console.log('actually showing activity info at position ' + x + ',' + y);
    var view = $('#activityInfoView')
    $(view).css({
        visibility: 'visible',
        left:  x - view.width() / 2,
        top:   y + 10,
    });
}

function hideActivityInfo() {
    console.log('hideActivityInfo()');
    $('#activityInfoView').css({
        visibility: 'hidden'
    });
}
