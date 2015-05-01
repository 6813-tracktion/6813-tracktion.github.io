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

    "baseball":     {displayName: "Baseball",  icon: "baseball"},
    // "basketball":   {displayName: "Basketball",icon: "basketball"},
    "cycling":      {displayName: "Cycling",   icon: "cycling"},
    "curling":      {displayName: "Curling",   icon: "curling"},
    "indoorbike":   {displayName: "Indoor Bike", icon: "exercise-bike"},
    "lifting":      {displayName: "Lifting",   icon: "dumbbell"},
    "karate":       {displayName: "Karate",    icon: "karate"},
    "polka":        {displayName: "Polka",     icon: "../../../iconarchive/polka"},
    "pushups":      {displayName: "PushUps",   icon: "pushups"},
    "running":      {displayName: "Running",   icon: "running"},
    "sitting":      {displayName: "Aggressive Sitting", icon: "../../../flaticon/sitting"},
    "stretching":   {displayName: "Stretching",icon: "stretching"},
    "swimming":     {displayName: "Swimming",  icon: "swimming"},
    "treadmill":    {displayName: "Treadmill", icon: "treadmill"},
    "yoga":         {displayName: "Yoga",      icon: "yoga"}
    // TODO add more if desired
};

var DISPLAY_NAMES_2_ACTIV_NAMES = {};
for (var activ in DEFAULT_ACTIVITY_TYPES) {
    var obj = DEFAULT_ACTIVITY_TYPES[activ];
    DISPLAY_NAMES_2_ACTIV_NAMES[obj.displayName] = activ;
}

function displayNameForLabel(lbl) {
    knownActivity = DEFAULT_ACTIVITY_TYPES[lbl];
    return knownActivity ? knownActivity.displayName : lbl;
}

// function activityForDisplayName(name) {
//     var activKey = DISPLAY_NAMES_2_ACTIV_NAMES[name];
    // var activObj = DEFAULT_ACTIVITY_TYPES[activKey];
//     return activObj;
// }

function getAllActivities(request, response) {
    var baseTypes = Object.keys(DEFAULT_ACTIVITY_TYPES).map(function(a){
        return DEFAULT_ACTIVITY_TYPES[a].displayName;
    });
    // custom types
    var customTypes = [];
    var customMap = {};
    window.dataset.get('sessions').forEach(function(session){
        var label = session.get('label');
        if(label.toLowerCase() in customMap)
            return;
        if(label in DEFAULT_ACTIVITY_TYPES)
            return;
        if(label.length){
            label = label.charAt(0).toUpperCase() + label.substring(1);
        }
        customTypes.push(label);
        customMap[label.toLowerCase()] = label;
    });
    // final types
    var types = baseTypes.concat(customTypes).filter(function(a){
        return a.toLowerCase().indexOf(request.term.toLowerCase()) > -1;
    });
    // TODO add all types ever, not just defaults
    types.sort();
    response(types);
}

function normalizeActivity(label) {
    // @see http://www.regular-expressions.info/refcharclass.html
    return label.replace(/[^a-zA-Z ]+/g, '') // remove invalid characters
                .replace(/ +/g, ' ') // remove duplicate spaces
                .replace(/^ +/, '') // trim prepending spaces
                .replace(/ +$/, '') // trim appending spaces
                .toLowerCase(); // to lower case
}

///// ACTIVITY INFO POPUP /////////////////////////////////////////////////////

function setupActivity(){

    // make the text field be an autocomplete text (this plays poorly
    // with the dropdown, but would be preferable)
    $('#activityTypeInput').autocomplete({
        source: getAllActivities,
        appendTo: '#activityInfoView',
        minLength: 0
    });

    // don't close the popup when clicked
    $('.dropdown-menu').click(function(e) {
          e.stopPropagation();
    });
    $('#cancelActivityInfo').click(function(e){
        e.preventDefault();
        hideActivityInfo(false);
    });
    $('#submitActivityInfo').click(submitActivityInfo);
    $('#deleteSession').click(deleteSession);

    $('#activityLayer').click(function(e){
        if(e.target != e.currentTarget)
            return;
        e.preventDefault();
        hideActivityInfo(false);
    });

    // submitting the form on <Enter>
    $('#activityTypeInput, #durationInput').keypress(function(e) {
        if(e.which == 13){
            $(this).blur();
            $('#submitActivityInfo').focus().click();
            return false;
        }
    });

    // duration and <Ok/Delete> labeling
    $('#durationInput').on('change', function(){
        var valid = validateInput();
        var duration = parseDuration($('#durationInput').val());
        var isDelete = duration <= 0;
        // The Delete button is right there... do we need to do anything else
        // besides disable the Okay button?
        $('#submitActivityInfo').prop('disabled', isDelete || !valid)
                                .toggleClass('disabled', isDelete || !valid);
        /*
        $('#submitActivityInfo').text(isDelete ? 'Delete' : 'Okay');
        if(isDelete)
            $('#submitActivityInfo').addClass('btn-danger');
        else
            $('#submitActivityInfo').removeClass('btn-danger');
        */
    });
}

function validateInput(){
    var duration = $('#durationInput').val();
    if(!duration.match(/^[1-9]*[05]$/) && !duration.match(/[0-9]+:[0-9]{2}/)){
        // TODO maybe provide message to user
        // (though HTML-5 browsers already give a hint with red highlight and tooltip on hover)
        return false;
    }
    return true;
}

// @see http://help.dottoro.com/ljtfkhio.php
function selectContentOf(node){
    var len = $(node).val().length;
    if('selectionStart' in node){
        node.selectionStart = 0;
        node.selectionEnd = len;
        node.focus();
    } else {
        var inputRange = node.createTextRange();
        inputRange.moveStart('character', 0);
        inputRange.collapse();
        inputRange.moveEnd('character', len);
        inputRange.select();
    }
}

function showActivityInfo(session, callback, selectType, isCreate) {
    var layer = $('#activityLayer');
    // bind edited data
    layer.data('session', session);
    layer.data('callback', callback);

    // set date
    layer.find('#activityDate').text(moment(session.get('date')).format('ddd, MMM D'));

    // set fields according to session
    var durationInput = $('#durationInput');
    var duration = session.get('duration');
    durationInput.val(formatDuration(duration));

    var activ = session.get('label');
    // let the record show that Alex wrote this line
    var activityType = $('#activityTypeInput');
    activityType.val((DEFAULT_ACTIVITY_TYPES[activ] || {displayName: activ}).displayName);

    // since we are showing => duration > 0 => can save without deleting
    $('#submitActivityInfo').prop('disabled', false);

    // show delete button iff editing an existing session; update layout
    if (isCreate) {
        $('#deleteSession').hide();
        $('#activityInfoView button').removeClass('col-xs-4').addClass('col-xs-6');
    } else {
        $('#deleteSession').show();
        $('#activityInfoView button').removeClass('col-xs-6').addClass('col-xs-4');
    }

    // show layer
    layer.stop().fadeIn();

    // disable scrolling
    lockScroll();

    // select duration input
    // Note: the field must be visible for that to work!
    durationInput.blur();
    activityType.blur();
    if(selectType){
        activityType.val('');
        selectContentOf(activityType[0]);
        activityType.autocomplete('search', '');
    } else {
        selectContentOf(durationInput[0]);
    }
}

function hideActivityInfo(isOK) {
    var layer = $('#activityLayer');

    // trigger callback
    var callback = layer.data('callback') || function(){ console.log('No callback!'); };
    callback(isOK);

    //  hide
    layer.stop().fadeOut(400, unlockScroll);
}

function submitActivityInfo() {
    var layer = $('#activityLayer');
    var session = layer.data('session');

    // don't submit unless it's valid
    if(!validateInput()){
        return;
    }

    // update model (callback is responsible for the commit)
    var duration = parseDuration($('#durationInput').val());
    session.set('duration', duration);

    var displayName = $('#activityTypeInput').val();
    var activName = DISPLAY_NAMES_2_ACTIV_NAMES[displayName] || normalizeActivity(displayName);
    session.set('label', activName);

    // hide
    hideActivityInfo(true);
}

function deleteSession() {
    var layer = $('#activityLayer');
    var session = layer.data('session');
    // Easiest to let the caller take care of the actual deletion.
    session.set('duration', 0);
    hideActivityInfo(true);
}


///////////////////////////////////////////////////////////////////////////////
///// SCROLL LOCK /////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// @see http://stackoverflow.com/questions/3656592/how-to-programmatically-disable-page-scrolling-with-jquery
function lockScroll(){
    var $html = $('html'); 
    var $body = $('body'); 
    var initWidth = $body.outerWidth();
    var initHeight = $body.outerHeight();

    var scrollPosition = [
        self.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft,
        self.pageYOffset || document.documentElement.scrollTop  || document.body.scrollTop
    ];
    $html.data('scroll-position', scrollPosition);
    $html.data('previous-overflow', $html.css('overflow'));
    $html.css('overflow', 'hidden');
    window.scrollTo(scrollPosition[0], scrollPosition[1]);   

    var marginR = $body.outerWidth()-initWidth;
    var marginB = $body.outerHeight()-initHeight; 
    $body.css({'margin-right': marginR,'margin-bottom': marginB});

    // special fixed elements
    $('.navbar-fixed-top').css({ 'padding-right': marginR });
}
function unlockScroll(){
    var $html = $('html');
    var $body = $('body');
    $html.css('overflow', $html.data('previous-overflow'));
    var scrollPosition = $html.data('scroll-position');
    window.scrollTo(scrollPosition[0], scrollPosition[1]);    

    $body.css({'margin-right': 0, 'margin-bottom': 0});

    // fixed elements
    $('.navbar-fixed-top').css({ 'padding-right': 0 });
}
