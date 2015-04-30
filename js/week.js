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
        // See comment in GR5 notes
        this.throttledRender = _.throttle(this.render, 100);
        this.listenTo(this.weekSessions, 'add change remove reset', this.throttledRender);
        this.listenTo(this.model, 'change', this.throttledRender);
        this.listenTo(this.model.attributes.dataset, 'change:today', this.throttledRender);
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
        // only update pixels per minute when not dragging
        if(!this.dragGoalInfo && !this.dragInfo){
            this.pixelsPerMin = 700.0 / Math.max(420, Math.max(this.model.get('goal'), sum) * 1.2);
        }
    },
    onShow: function() { // called once
        this.fixSVGFractionalCoordinates();
    },
    onDomRefresh: function () { // last callback after model change
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
            this.throttledRender();
        } catch (e) {}
    },
    templateHelpers: function() {
        return {
            self: this,
            DAY_HEIGHT_PX: DAY_HEIGHT_PX,
            include: function(tmpl){
                return templates[tmpl];
            },
            maxMinutes: function() {
                return 700.0 / this.self.pixelsPerMin;
            },
            maxHours: function() {
                return Math.ceil(this.maxMinutes() / 60.0);
            },
            ppm: function() {
                return this.self.pixelsPerMin;
            },
            // Round so our 1px borders are aligned with the screen pixels.
            rm2p: function(min) {
                return Math.round(min * this.self.pixelsPerMin);
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
      // session creation + modification
      "mousedown rect.session":     "mousedownSession",
      "mousedown rect.new-session": "mousedownPlus",
      "mousedown path.new-session": "mousedownPlus",
      // goal modification
      "mousedown g.goal":           "mousedownGoal",
      // hover info callbacks
      "mouseover g.goal":           "mouseoverGoal",
      "mouseout g.goal":            "mouseoutGoal",
      "mouseover rect.session":     "mouseoverSession",
      "mouseout rect":              "mouseoutRect",
      "mouseover rect.gapRemaining":   "mouseoverGap",
      "mouseout rect.gapRemaining":    "mouseoutGap",
      // other events
      "click .editableEndDate":     "changeEndDate"
      // Implicit by setting window.dragHandler = this.
      //"mousemove": "mousemove",
      //"mouseup": "mouseup",
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
            origDuration: this.model.get('goal'),
            startTime: moment()
        };
        window.startDrag(this);
    },
    mouseoverGoal: function(event) {
        // TODO would be nice to mirror pattern for session tooltip wherein
        // we also show it when dragged, but no cid for goal elements
        showToolTipForGoal(this.model.get('goal'), event.target);
    },
    mouseoutGoal: function(event) {
        hideToolTipForGoal();
    },
    mouseoverGap: function(event) {
        var weekTotal = this.templateHelpers().weekTotal();
        var gapTime = this.model.get('goal') - weekTotal;
        showToolTipForGap(gapTime, weekTotal * this.pixelsPerMin, event.target);
    },
    mouseoutGap: function(event) {
        hideToolTipForGap();
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
        this.throttledRender();  // update drag-target class
        window.startDrag(this);
    },
    mousemove: function(event){
        event.preventDefault();
        if (this.dragInfo) {
            var newDuration = Math.max(0,
                    this.dragInfo.origDuration +
                    (event.pageX - this.dragInfo.origMouseX) / this.pixelsPerMin);
            newDuration = DURATION_GRANULARITY * Math.round(newDuration / DURATION_GRANULARITY);
            this.dragInfo.session.set('duration', newDuration);

            showToolTipForSession(this.dragInfo.session);
        }
        if (this.dragGoalInfo) {
            var newDuration = Math.max(0,
                    this.dragGoalInfo.origDuration +
                    (event.pageX - this.dragGoalInfo.origMouseX) / this.pixelsPerMin);
            newDuration = DURATION_GRANULARITY * Math.round(newDuration / DURATION_GRANULARITY);
            // move goal line and flag
            this.model.set('goal', newDuration);
        }
    },
    mouseup: function(event){
        if (this.dragInfo) {
            var dragInfo = this.dragInfo;
            this.dragInfo = null;
            this.throttledRender();  // update drag-target class

            // is it a click or a drag?
            // XXX: Ideally this time threshold would be a system setting
            // like the double-click timeout.
            var isClick = moment().diff(dragInfo.startTime, 'milliseconds') < 300;

            hideToolTipForSession();
            hideToolTipForGoal();

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
            var goalInfo = this.dragGoalInfo;
            this.dragGoalInfo = null;

            var isClick = moment().diff(goalInfo.startTime, 'millisecond') < 300;
            var duration = goalInfo.origDuration;

            if (isClick) {
                hideToolTipForGoal();

                showGoalDialog(duration, this.updateGoal.bind(this));
                event.stopPropagation(); // event outside -> close popup
                return;
            }
            this.updateGoal();
            /*
            // Threshold is pageX >= 990
            if ( event.pageX >= 990 ) {
                PX_PER_MIN = PX_PER_MIN / (1.2)
            }
            console.log(PX_PER_MIN);
            */

            this.throttledRender();
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
    updateGoal: function(duration, isOk){
        if(isOk) {
           this.model.set('goal', duration);
           undoManager.commit();
        }
        this.throttledRender();
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

// ------------------------ showing tooltips

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
    var offset = offsetToAboveCenterOfElement(tip, element);
    moveToElementPlusOffset(tip, element, offset.x, offset.y);
}

function showToolTipForGoal(goalMins, element) {
    showDurationToolTip(goalMins, element, -7, -30);
}

function showToolTipForGap(gapMins, weekTotal, element) {
    var tip = $('#durationToolTip');
    var offset = offsetToAboveCenterOfElement(tip, element);
    var x = offset.x + weekTotal; // wasn't getting abs position of rect properly
    showDurationToolTip(gapMins, element, x, offset.y);
}

// ------------------------ hiding tooltips

function hideToolTipForSession() {
    $('#sessionToolTip').css('opacity', 0);
}
function hideToolTipForGoal() {
    hideDurationToolTip();
}
function hideToolTipForGap() {
    hideDurationToolTip();
}

// ------------------------ helper funcs

// inner func for goal and gap tooltips
function showDurationToolTip(durationMins, element, dx, dy) {
    var tip = $('#durationToolTip');
    $(tip).css('opacity', 1);
    var durationStr = formatDuration(durationMins, '0');
    $(tip).html(durationStr);
    moveToElementPlusOffset(tip, element, dx, dy);
}
function hideDurationToolTip() {
    $('#durationToolTip').css('opacity', 0);
}

function offsetToAboveCenterOfElement(tip, element) {
    var wGap = element.getAttribute("width");
    var wTip = $(tip).width();
    var dx = -wTip / 2 + wGap / 2 - 4;
    return {x: dx, y: -30};
}

// ------------------------------------------------
// Intro / help
// ------------------------------------------------
// These 4 functions work together to:
//  1) only show *any* help if there are no sessions
//  2) hide help for adding a new session and changing the goal independently,
//      with the help permanently hidden once some condition is met

function showIntroIfNeeded(allSessions) {
    if (allSessions.length == 0) {
        showIntroElements();
    }
}

function showIntroElements() {
    showAddNewButton();
    // XXX hack to make tooltips appear in right place, since views to
    // which they move still aren't positioned properly at time of the
    // latest marionette callback (onDomRefresh())
    setTimeout(showHelpToolTips, 1500);
}

function hideAddNewHelp() {
    $('#addNewHelp').css('visibility', 'hidden');
}
function hideGoalHelp() {
    $('#goalHelp').css('visibility', 'hidden');
}

function showHelpToolTips() {
    // position the goal help
    var goal = $('.goal')[0];
    var goalHelp = $('#goalHelp')[0];
    moveToElementPlusOffset(goalHelp, goal, 41, 2);

    // position the add new session help
    var addNewSquare = $('path.new-session[data-is-today="' + "true" + '"]')[0];
    var addNewHelp = $('#addNewHelp')[0];
    moveToElementPlusOffset(addNewHelp, addNewSquare, 24, -14);

    // make help dialogs visible
    $('.help').css('opacity', 1);
}

// these two funcs are separate from the others because the add new button
// may need to be set to visible multiple times if the end date is changed,
// since the normal behavior is to hide it except when its row is moused over
function showAddNewIfNeeded(allSessions) {
    if (allSessions.length == 0) {
        showAddNewButton();
    }
}
function showAddNewButton() {
    // show the new session button even if user not mousing over the row
    var firstSessionEls = $('.new-session[data-is-today="' + "true" + '"]');
    $(firstSessionEls).css('visibility', 'visible');
}
