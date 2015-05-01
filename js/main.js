// based on: http://tutorialzine.com/2013/04/services-chooser-backbone-js/
async.waterfall([
  // 1 = wait for DOM
  function domReady(cb){
    $(document).ready(function(){
      cb();
    });
  },
  // 2 = load templates
  loadTemplates
],
  // 3 = setup application
  function initialize(err, templates){
    if(err){
      console.log('Error: %o', err);
    }

    // Give us functionality similar to Element.setCapture in all browsers.
    // Take the opportunity to centralize the 'dragging' class here too.
    window.startDrag = function(dragHandler) {
        window.dragHandler = dragHandler;
        $('body').addClass('dragging');
    };
    window.dragHandler = null;
    window.addEventListener('mousemove', function(event) {
        if (window.dragHandler) {
            window.dragHandler.mousemove(event);
        }
    });
    window.addEventListener('mouseup', function(event) {
        if (window.dragHandler) {
            window.dragHandler.mouseup(event);
            window.dragHandler = null;
            $('body').removeClass('dragging');
        }
    });

    // 1. Retrieve model - which one to load depends on url args
    var dataset;
    var isFresh = getUrlParameter('fresh');
    if (isFresh) {
      dataset = loadFreshModel();
    } else {
      dataset = loadModel();
    }
    window.dataset = dataset;

    // Set up undo manager.
    var undoManager = new Backbone.UndoManager({
        register: [dataset, dataset.attributes.sessions, dataset.attributes.weeks],
        track: true
        });
    // So that all code can call commit.  There has to be a proper way to do this...
    window.undoManager = undoManager;
    var updateUndoButtons = function() {
        $('#undo').prop('disabled', !undoManager.isAvailable('undo'));
        $('#redo').prop('disabled', !undoManager.isAvailable('redo'));
    };
    updateUndoButtons();
    undoManager.on('availabilityMayHaveChanged', updateUndoButtons);
    $('#undo').click(function() { undoManager.undo(true); });
    $('#redo').click(function() { undoManager.redo(true); });

    // Set up "Simulated current date" control.
    $('#mockToday').datepicker();
    var todayModelToView = function() {
        // Seems to match format generated by datepicker.
        $('#mockToday').val(dataset.attributes.today.format('L'));
    };
    todayModelToView();
    dataset.on('change:today', todayModelToView);
    $('#mockToday').on('change', function() {
        var newToday = moment($('#mockToday').val(), 'L');
        // We might hope Backbone would check this before firing events, but
        // JavaScript has no convention for an overridable equals method...
        if (!newToday.isSame(dataset.attributes.today)) {
            dataset.set('today', newToday);
            // We don't really need to support undo for this control, but it's
            // harmless and easier than not supporting it (i.e., clearing the
            // undo/redo stack).
            undoManager.commit();
        }
    });

    // Set up "jump to date"
    $('#jumpToDate').datepicker();
    var BODY_PADDING_PX = 100;
    var updateJumpToDate = function() {
        // http://stackoverflow.com/questions/2230880/jquery-javascript-find-first-visible-element-after-scroll
        var cutoff = $(document).scrollTop() + BODY_PADDING_PX;
        $('div.week').each(function() {
            if ($(this).offset().top >= cutoff) {
                var week = dataset.attributes.weeks.get($(this).data('cid'));
                $('#jumpToDate').val(week.attributes.end.format('L'));
                return false;
            }
        });
        // If the oldest goal period is extremely long, we could fall through
        // without updating the field.
    };
    // There's no point in calling updateJumpToDate now: no weeks are rendered.
    // The view will call it after rendering.
    window.updateJumpToDate = updateJumpToDate;  // hack
    $(document).scroll(_.throttle(updateJumpToDate, 100, {leading: false}));
    window.scrollToWeek = function(week) {
        var weekView = $('div.week[data-cid=' + week.cid +']');
        window.scrollTo(0, weekView.offset().top - BODY_PADDING_PX);
        updateJumpToDate();
    };
    $('#jumpToDate').on('change', function() {
        var wantDate = moment($('#jumpToDate').val(), 'L');
        var wantWeek = dataset.attributes.weeks.find(function(w) {
            return !wantDate.isBefore(w.attributes.beginning);
        });
        if (!wantWeek) {
            // If a very old date was entered, go to the oldest week.
            // XXX: Instead should we add older weeks to let the user enter historical data?
            wantWeek = dataset.attributes.weeks.at(dataset.attributes.weeks.length - 1);
        }
        window.scrollToWeek(wantWeek);
    });

    // duration inputs
    $('input.duration').mask("99:90", {
        placeholder: "hh:mm",
        selectOnFocus: true,
        clearIfNotMatch: true
    }).keydown(function(e){
      var dir = -1;
      switch(e.which){
        case 38:
            dir *= -1; // going up
        case 40: {
            var incr = 5;
            var duration = parseDuration($(this).val()) || 0;
            duration = Math.round(duration / incr) * incr; // round to closest multiple of $incr
            duration += dir * incr;
            $(this).val(formatDuration(duration));
        } break;
      }
    });

    // 2. Setup stuff ...
    setupActivity();
    setupGoal();

    // 3. Setup application
    var app = new Marionette.Application();
    app.addRegions({
        weekList: '#weeks',
        longRangeView: '#longRangeView',
    });
    app.on('start', function(options){
        console.log('Started Marionette application, options = %o', options);

        if(Backbone.history){
            Backbone.history.start();
        }
    });
    app.weekList.show(new FullView({model: dataset}));
    app.longRangeView.show(new LongRangeView({model: dataset}));

    // 4. Start the application
    app.start();
     
    // 5. We're done rendering now
    setTimeout(function(){
        $('#loader').fadeOut(600, function(){
            $('.loadable').removeClass('loadable');
        });
        $('.loadable').fadeIn(800);
    }, 400);
    
    var settings = $('#settingsPic');
    $(settings).click(function(e) {
        // Show our internal options
        console.log(e);
    });
});
