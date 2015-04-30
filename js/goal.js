/**
 * Goal functions
 */

function setupGoal(){
    // Make the goal box visible
    $('#setGoal').click(submitGoalDialog);
    $('#cancelSetGoal').click(function(e){
        e.preventDefault();
        hideGoalDialog();
    });
    $('#goalLayer').click(function(e){
        if(e.target != e.currentTarget)
            return;
        e.preventDefault();
        hideGoalDialog();
    });
    // submitting the form on <Enter>
    $('#goalDuration').keypress(function(e) {
        if(e.which == 13){
            $(this).blur();
            $('#setGoal').focus().click();
            return false;
        }
    });
}

function showGoalDialog(duration, callback){
    var layer = $('#goalLayer');
    layer.stop().fadeIn();
    layer.data('callback', callback);

    var hours = Math.floor(duration / 60);
    var minutes = duration % 60;
    var goalDuration = layer.find('#goalDuration');
    goalDuration.val(hours + ':' + (minutes < 10 ? '0' + minutes : minutes));

    // lock scroll
    selectContentOf(goalDuration[0]);
}

function submitGoalDialog(){
    var time = $('#goalDuration').val();
    var tokens = time.split(':');
    var duration = parseInt(tokens[tokens.length - 1] || 0, 10) + parseInt(tokens[tokens.length - 2] || 0, 10) * 60;
    // duration = DURATION_GRANULARITY * Math.round(duration / DURATION_GRANULARITY);
    if(duration > 0){
        hideGoalDialog(duration, true);
    } else {
        // TODO alert user that there's a problem
    }
}

function hideGoalDialog(duration, isOk){
    var callback = $('#goalLayer').data('callback') || function(){};
    $('#goalLayer').stop().fadeOut(400, unlockScroll);
    callback(duration, isOk);
}
