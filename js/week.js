/**
 * Week-related views
 */

var DURATION_GRANULARITY = 5;

var DAY_HEIGHT_PX = 42;  // Keep in sync with svg {...} in main.css
var PX_PER_MIN = 700 / 420;

var weekGoal = 300;

// @see http://jsfiddle.net/bryanbuchs/c72Vg/
var WeekView = Marionette.ItemView.extend({
    template: "#weekTpl",
    className: "week",
    attributes: function() {
        // Used by "jump to date" code.
        return {'data-cid': this.model.cid};
    },
    initialize: function(options) {
        this.weekSessions = this.model.attributes.sessions;
        this.dataset = this.model.attributes.dataset;
        this.allSessions = this.dataset.attributes.sessions;
        this.listenTo(this.weekSessions, 'add', this.render);
        this.listenTo(this.weekSessions, 'change', this.render);
        this.listenTo(this.weekSessions, 'remove', this.render);
        this.listenTo(this.model, 'change', this.render);
        this.listenTo(this.model.attributes.dataset, 'change:today', this.render);
        this.dragInfo = null;
        this.goalDragInfo = null;
        this.svgStyleAttr = '';
        // http://stackoverflow.com/questions/14460855/backbone-js-listento-window-resize-throwing-object-object-has-no-method-apply
        this.resizeCallback = _.bind(this.fixSVGFractionalCoordinates, this);
        $(window).on('resize', this.resizeCallback);
    },
    remove: function() {
        $(window).off('resize', this.resizeCallback);
        Marionette.ItemView.prototype.remove.apply(this, arguments);
    },
    onBeforeRender: function() {
        this.byDay = this.weekSessions.groupBy(function(session, i) {
            return session.day();
        });
        // cache
        this.beginning = this.model.attributes.beginning;
        this.end = this.model.attributes.end;
        this.cumulativeSum = {};
        var day = moment(this.beginning);
        var sum = 0;
        while(+day <= this.end){
            var key = dayFormat(day);
            sum += _.reduce(this.byDay[key] || [], function(sum, session) {
                return sum + session.attributes.duration;
            }, 0);
            this.cumulativeSum[key] = sum;
            day = day.add(1, 'days');
        }
    },
    onShow: function() {
        this.fixSVGFractionalCoordinates();
        showIntroIfNeeded(this.allSessions);
    },
    fixSVGFractionalCoordinates: function() {
        // https://bugzilla.mozilla.org/show_bug.cgi?id=608812
        // Not sure if this works in all browsers.
        try {
            this.$('svg').attr('style', '');
            var ctm = this.$('svg')[0].getScreenCTM();
            this.svgStyleAttr = 'position: relative; ' +
                'top: ' + -(ctm.f % 1) + 'px; left: ' + -(ctm.e % 1) + 'px;';
            this.render();
        } catch (e) {}
    },
    templateHelpers: function() {
        return {
            self: this,
            DAY_HEIGHT_PX: DAY_HEIGHT_PX,
            include: function(tmpl){
                return templates[tmpl];
            },
            // Round so our 1px borders are aligned with the screen pixels.
            rm2p: function(min) {
                return Math.round(PX_PER_MIN * min);
            },
            weekAttr: function(name) {
                return this.self.model.get(name);
            },
            attr: function(model, name){
                return model.get(name);
            },
            urlVar: function(name){
                return getUrlParameter(name);
            },
            sessionClass: function(session){
                if(this.self.dragInfo)
                    return this.self.dragInfo.session.cid == session.cid ? "drag-target" : "";
                return "";
            },
            iconURL: function(session){
                var label = session.get('label');
                var data = DEFAULT_ACTIVITY_TYPES[label] || DEFAULT_ACTIVITY_TYPES['unspecified'];
                return "img/freepik-icons/png/neg/" + data.icon + '.png';
            },
            iconClass: function(session){
                var label = session.get('label');
                return label == 'unspecified' || !(label in DEFAULT_ACTIVITY_TYPES) ? 'bad' : 'good';
            },
            today: this.dataset.attributes.today,
            numDaysToShow: function() {
                var lastDay = this.today.isBefore(this.self.end) ? this.today : this.self.end;
                return lastDay.diff(this.self.beginning, 'days') + 1;
            },
            reversedDays: function() {
                var ds = _.range(this.numDaysToShow());
                ds.reverse();
                return ds;
            },
            day: function(i){
                return moment(this.self.beginning).add(i, 'days');
            },
            daySessions: function(i) {
                var day = this.day(i);
                return this.self.byDay[dayFormat(day)];
            },
            emptyDay: function(day) {
                return !this.daySessions(day);
            },
            daySum: function(day, upTo) {
                if(arguments.length < 2)
                    upTo = Infinity;
                var sessionList = this.daySessions(day) || [];
                return _.reduce(sessionList.slice(0, upTo), function(sum, session){
                  return sum + session.attributes.duration;
                }, 0);
            },
            cumulative: function(i) {
                var m = this.day(i);
                return this.self.cumulativeSum[dayFormat(m)];
            },
            weekTotal: function() {
                // There shouldn't be future sessions...
                return this.cumulative(this.numDaysToShow() - 1);
            },
            weekNumber: function(){
                return this.self.beginning.format('W');
            },
            canChangeEnd: function(){
                return this.self.dataset.attributes.weeks.indexOf(this.self.model) <= 1;
            },
            goalLineColor: function(px) {
                var defaultPixel = 500;
                return px >= defaultPixel ? "rgb(0,150,0)":"rgb(225,0,0)";
            },
            totalBarColor: function(mins) {
                var goalMins = this.self.model.get('goal');
                return mins >= goalMins ? "fill:rgb(0,150,0)":"fill:rgb(227,227,22)";
            }
        };
    },
    events: {
      "mousedown rect.session":     "mousedownSession",
      "mousedown rect.new-session": "mousedownPlus",
      "mousedown path.new-session": "mousedownPlus",
      // Implicit by setting window.dragHandler = this.
      //"mousemove": "mousemove",
      //"mouseup": "mouseup",
      "mousedown g.goal":           "mousedownGoal",
      // hover info callbacks
      "mouseover g.goal":           "mouseoverGoal",
      "mouseout g.goal":            "mouseoutGoal",
      "mouseover rect.session":     "mouseoverSession",
      "mouseout rect":              "mouseoutRect",
      "click .editableEndDate":     "changeEndDate"
    },
    mousedownSession: function(event){
        event.preventDefault();
        var cid = $(event.target).data('cid');
        this.startDragging(this.weekSessions.get(cid), false, event);
    },
    mousedownPlus: function(event){
        event.preventDefault();
        var day = $(event.target).data('day');
        var date = this.templateHelpers().day(day);
        var newSession = new Session({date: date});
        this.allSessions.add(newSession);
        // The view should render synchronously, so the new rect should be
        // present in the DOM if we need it.
        this.startDragging(newSession, true, event);
        hideAddNewHelp();
    },
    mousedownGoal: function(event) {
        event.preventDefault();
        hideGoalHelp();
        this.dragGoalInfo = {
            origMouseX : event.pageX,
            origDuration: this.model.get('goal')
        };
        window.startDrag(this);
    },
    mouseoverGoal: function(event) {
        showToolTipForGoal(this.model.get('goal'), event.target);
    },
    mouseoutGoal: function(event) {
        hideToolTipForGoal();
    },
    mouseoverSession: function(event) {
        if (this.dragInfo) {
            return;
        }
        session = sessionForEvent(this, event);
        showToolTipForSession(session);
    },
    mouseoutRect: function(event) {
        hideToolTipForSession();
    },
    startDragging: function(session, isCreate, event){
        this.dragInfo = {
                session: session,
                isCreate: isCreate,
                startTime: moment(),
                origDuration: session.attributes.duration,
                origMouseX: event.pageX
        };
        this.render();  // update drag-target class
        window.startDrag(this);
    },
    mousemove: function(event){
        event.preventDefault();
        if (this.dragInfo) {
            var newDuration = Math.max(0,
                    this.dragInfo.origDuration +
                    (event.pageX - this.dragInfo.origMouseX) / PX_PER_MIN);
            newDuration = DURATION_GRANULARITY * Math.round(newDuration / DURATION_GRANULARITY);
            this.dragInfo.session.set('duration', newDuration);

            showToolTipForSession(this.dragInfo.session);
        }
        if (this.dragGoalInfo) {
            var newDuration = Math.max(0,
                    this.dragGoalInfo.origDuration +
                    (event.pageX - this.dragGoalInfo.origMouseX) / PX_PER_MIN);
            newDuration = DURATION_GRANULARITY * Math.round(newDuration / DURATION_GRANULARITY);
            // move goal line and flag
            this.model.set('goal', newDuration);
        }
    },
    mouseup: function(event){
        if (this.dragInfo) {
            var dragInfo = this.dragInfo;
            this.dragInfo = null;
            this.render();  // update drag-target class

            // is it a click or a drag?
            // XXX: Ideally this time threshold would be a system setting
            // like the double-click timeout.
            var isClick = moment().diff(dragInfo.startTime, 'milliseconds') < 300;

            hideToolTipForSession();

            // if creating a session, ask for activity type and duration
            if (dragInfo.isCreate) {
                if(dragInfo.session.attributes.duration <= 0){
                  // just delete, do not show
                  this.updateSession(dragInfo.session, dragInfo.isCreate, false); // equivalent to showing and canceling
                } else {
                  showActivityInfo(dragInfo.session, this.updateSession.bind(this, dragInfo.session, dragInfo.isCreate), !isClick);
                }
                event.stopPropagation();
                // TODO set duration to activity's current duration (some
                // default if just a click on plus) to handle both
                // click and drag cases
                return;
            }

            if (isClick) {
                undoManager.rollback();  // in case there was a short drag before the click
                showActivityInfo(dragInfo.session, this.updateSession.bind(this, dragInfo.session, dragInfo.isCreate));
                event.stopPropagation(); // event outside -> close popup
                return;
            }

            // Delete if duration has been reduced to zero.
            this.updateSession(dragInfo.session, false, true);
        }

        if (this.dragGoalInfo) {
            console.log(this.model.get('goal'));
            console.log(event.pageX);


            if (this.dragGoalInfo.origMouseX === event.pageX) {
                hideToolTipForGoal();

                // Make the goal box visible
                $('#setGoalContainer').fadeIn();
                console.log(this.model.get('goal'));

                var duration = this.dragGoalInfo.origDuration;

                $('#setGoal').click(_.bind(function(e) {
                    var hours = parseInt($('#hourDuration').val());
                    var mins = parseInt($('#minuteDuration').val());

                    duration = hours * 60 + mins;
                    duration = DURATION_GRANULARITY * Math.round(duration / DURATION_GRANULARITY);

                    console.log("hours: " + hours + " mins: " + mins + " duration: " + duration);

                    this.model.set('goal', duration);
                    var resizeFactor = Math.ceil(duration/60.0);

                    $('#setGoalContainer').fadeOut();

                    if ( resizeFactor !== 0 && this.templateHelpers().weekTotal() < duration )
                        PX_PER_MIN = 10 / resizeFactor;
                    this.render();
                }, this));

                $('#cancelSetGoal').click(function(e) {
                    $('#setGoalContainer').fadeOut();
                });


            }
            // Threshold is pageX >= 990
            if ( event.pageX >= 990 ) {
                PX_PER_MIN = PX_PER_MIN / (1.2)
            }
            console.log(PX_PER_MIN);


            this.render();
            this.dragGoalInfo = null;
            undoManager.commit();
        }
    },
    updateSession: function(session, isCreate, isOK){
        if (!isOK) {
            // If !isCreate, there normally should be nothing to roll back.
            undoManager.rollback();
        } else {
            if (session.attributes.duration == 0) {
                this.allSessions.remove(session);
            }
            undoManager.commit();
        }
    },
    changeEndDate: function(event){
        this.$('.editableEndDate').datepicker(
                'dialog',
                this.model.attributes.end.format('L'),
                _.bind(this.setEndDate, this),
                // Do not allow making a period with less than one day.
                {minDate: this.model.attributes.beginning.format('L')},
                event);
    },
    setEndDate: function(endDateStr){
        var endDate = moment(endDateStr, 'L');
        this.model.set('end', endDate);
        if (this.dataset.attributes.weeks.indexOf(this.model) == 1) {
            var nextWeek = this.dataset.attributes.weeks.at(0);
            if (endDate.isBefore(this.dataset.attributes.today)) {
                // Adjust the next goal period.
                nextWeek.set('beginning', moment(endDate).add(1, 'days'));
            } else {
                // The next goal period would start in the future.  Eat it.
                this.dataset.attributes.weeks.remove(nextWeek);
            }
        }
        // Conversely, if we're editing the current week so it now ends in the
        // past, we need to add a new current week. This case is handled by the
        // model itself.
        undoManager.commit();
        // If we moved days from one week to another...
        window.updateJumpToDate();
    }
});

var FullView = Marionette.CollectionView.extend({
    childView: WeekView,
    initialize: function() {
        this.collection = this.model.attributes.weeks;
    },
    onRender: function() {
        // May not be useful if called before show.
        window.updateJumpToDate();
    },
    onShow: function() {
        window.updateJumpToDate();
    },
});

// ------------------------------------------------
// Models <-> Views
// ------------------------------------------------

function cidForEvent(event) {
    return $(event.target).data('cid');
}

function sessionForCid(ths, cid) {
    return ths.weekSessions.get(cid);
}

function sessionForEvent(ths, event) {
    return sessionForCid(ths, cidForEvent(event));
}

function sessionElementForCid(cid) {
    return $('rect[data-cid=' + cid + ']')[0];
}

// ------------------------------------------------
// Tooltip hiding/showing
// ------------------------------------------------

function showToolTipForSession(session) {
    var tip = $('#sessionToolTip');
    $(tip).css('opacity', 1);

    // populate tooltip, making sure not to write "Unspecified" (this is
    // ugly, and espeically ugly when the user is dragging to create a new
    // session and intends to specify something)
    var duration = session.attributes.duration;
    var durationStr = formatDuration(duration, 'Delete');
    if (session.attributes.label == 'unspecified') {
        $(tip).html(durationStr);
    } else {
        var name = displayNameForLabel(session.attributes.label);
        $(tip).html(durationStr + ' ' + name);
    }

    // position tooltip
    var element = sessionElementForCid(session.cid);
    var wSesh = element.getAttribute("width");
    var wTip = $(tip).width();
    var dx = -wTip / 2 + wSesh / 2 - 3;
    moveToElementPlusOffset(tip, element, dx, -30);
}

function showToolTipForGoal(goalMins, element) {
    var tip = $('#durationToolTip');
    $(tip).css('opacity', 1);
    var durationStr = formatDuration(goalMins, '0');
    $(tip).html(durationStr);
    moveToElementPlusOffset(tip, element, -4, -38);
}

function hideToolTipForSession() {
    $('#sessionToolTip').css('opacity', 0);
}
function hideToolTipForGoal() {
    $('#durationToolTip').css('opacity', 0);
}

// ------------------------------------------------
// Intro / help
// ------------------------------------------------
// These 4 functions work together to:
//  1) only show *any* help if there are no sessions
//  2) hide help for adding a new session and changing the goal independently,
//      with the help permanently hidden once logic in the model has
//      determined that the user has successfully carried out the appropriate
//      actions
//
// We use opacity for making the tooltips visible because 'visibility',
// 'display', and jQuery 'fade{In,Out}' don't seem to work.

function showIntroIfNeeded(allSessions) {
    if (allSessions.length == 0) {
        showIntroElements();
    }
}

function showIntroElements() {
    // show the new session button even if user not mousing over the row
    console.log('making first session stuff visible');
    var firstSessionEls = $('.new-session[data-is-today="' + "true" + '"]');
    $(firstSessionEls).css('visibility', 'visible');

    // make help dialogs visible
    $('.help').css('opacity', 1);

    // position the goal help
    var goal = $('.goal')[0];
    var goalHelp = $('#goalHelp')[0];
    moveToElementPlusOffset(goalHelp, goal, 42, -10);

    // position the add new session help
    var addNewSquare = $('path.new-session[data-is-today="' + "true" + '"]')[0];
    var addNewHelp = $('#addNewHelp')[0];
    moveToElementPlusOffset(addNewHelp, addNewSquare, 24, -15);
}

function hideAddNewHelp() {
    $('#addNewHelp').css('visibility', 'hidden');
}
function hideGoalHelp() {
    $('#goalHelp').css('visibility', 'hidden');
}
