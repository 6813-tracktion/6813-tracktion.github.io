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
    // $('#durationInput').spinner();

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
    $.each(ALL_ACTIVITY_TYPES, function(i) {
        var typ = ALL_ACTIVITY_TYPES[i].get('displayName');
        activityTypeSelect.append('<option value="'+ typ + '" class="activityType">' + typ + '</option>');
    });

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

    // control numeric-only inputs
    $(document).on('keydown', '.numeric-only', function(event) {
        // we allow control key input
        if(event.keyCode <= 40){
            return;
        }
        /*
        var allowed = [8, 9, 13, 32, 37, 38, 39, 40];
        for(var i = 0; i < allowed.length; ++i){
            if(event.keyCode == allowed[i]){
                return;
            }
        }*/
        // and disallow any non-numeric non-control character
        if(!$.isNumeric(event.key)){
            event.preventDefault();
        }
    });

    /*
    // force durations to be numeric
    // adapted from http://stackoverflow.com/a/20186188/1153180
    $(document).on('keyup', '.numeric-only', function(event) {
        var v = this.value;
        if($.isNumeric(v) === false || v < 0) {
            this.value = this.value.slice(0,-1); // remove last char entered
        }
    });
    */

    $('#cancelActivityInfo').click(function(){
        e.preventDefault();
        hideActivityInfo();
    });
    $('#submitActivityInfo').click(submitActivityInfo);

    $('#activityLayer').click(function(e){
        if(e.target != e.currentTarget)
            return;
        e.preventDefault();
        hideActivityInfo();
    });
}
function showActivityInfo(session, callback) {
    var layer = $('#activityLayer');
    // bind edited data
    layer.data('session', session);
    layer.data('callback', callback);
    // set fields according to session
    $('#durationInput').val(session.get('duration'));

    // show layer
    layer.stop().fadeIn();
}

function hideActivityInfo() {
    var layer = $('#activityLayer');

    // trigger callback
    var callback = layer.data('callback') || function(){ console.log('No callback!'); };
    callback();

    //  hide
    layer.stop().fadeOut();
}

function submitActivityInfo() {
    var layer = $('#activityLayer');
    var session = layer.data('session');
    // update model
    session.set('duration', $('#durationInput').val());

    // hide
    hideActivityInfo();
}
