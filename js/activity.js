/**
 * Activity-related functions
 */
///// ACTIVITY TYPE ///////////////////////////////////////////////////////////

// var ActivityType = Backbone.Model.extend({
//     getIconPath: function() {
//         return "img/" + this.icon + ".png"
//     }
// });

var DEFAULT_ACTIVITY_TYPES = {
    "unspecified":  {displayName:"Unspecified",icon: "who-knows"},

    "running":      {displayName: "Running",   icon: "running"},
    "baseball":     {displayName: "Baseball",  icon: "baseball"},
    "basketball":   {displayName: "Basketball",icon: "basketball"},
    "swimming":     {displayName: "Swimming",  icon: "swimming"},
    "curling":      {displayName: "Curling",   icon: "curling"},
    // TODO add more if desired
}

var DISPLAY_NAMES_2_ACTIV_NAMES = {};
for (var activ in DEFAULT_ACTIVITY_TYPES) {
    var obj = DEFAULT_ACTIVITY_TYPES[activ];
    DISPLAY_NAMES_2_ACTIV_NAMES[obj.displayName] = activ;
}

// function activityForDisplayName(name) {
//     var activKey = DISPLAY_NAMES_2_ACTIV_NAMES[name];
    // var activObj = DEFAULT_ACTIVITY_TYPES[activKey];
//     return activObj;
// }

function getAllActivities(request, response) {
    var types = Object.keys(DEFAULT_ACTIVITY_TYPES).map(function(a){
        return DEFAULT_ACTIVITY_TYPES[a].displayName;
    }).filter(function(a){
        return a.toLowerCase().indexOf(request.term.toLowerCase()) > -1;
    });
    // TODO add all types ever, not just defaults
    types.sort();
    response(types);
}

///// ACTIVITY INFO POPUP /////////////////////////////////////////////////////

function setupActivity(){

    // make the text field be an autocomplete text (this plays poorly
    // with the dropdown, but would be preferable)
    $('#activityTypeInput').autocomplete({
        source: getAllActivities,
        minLength: 1
    });

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

    $('#cancelActivityInfo').click(function(e){
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
    var activ = session.get('label');
    // let the record show that Alex wrote this line
    $('#activityTypeInput').val((DEFAULT_ACTIVITY_TYPES[activ] || {displayName: activ}).displayName)

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
    session.set('duration', parseInt($('#durationInput').val(), 10));

    var displayName = $('#activityTypeInput').val();
    var activName = DISPLAY_NAMES_2_ACTIV_NAMES[displayName] || displayName;
    session.set('label', activName);

    // hide
    hideActivityInfo();
}
