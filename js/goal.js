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

    var goalDuration = layer.find('#goalDuration');
    goalDuration.val(formatDuration(duration));

    // lock scroll
    lockScroll();

    // automatic selection
    selectContentOf(goalDuration[0]);
}

function submitGoalDialog(){
    var duration = parseDuration($('#goalDuration').val());
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
