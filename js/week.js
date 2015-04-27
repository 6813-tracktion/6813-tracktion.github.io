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
    initialize: function(options) {
        this.weekSessions = this.model.attributes.sessions;
        this.listenTo(this.weekSessions, 'add', this.render);
        this.listenTo(this.weekSessions, 'change', this.render);
        this.listenTo(this.weekSessions, 'remove', this.render);
        this.listenTo(this.model, 'change', this.render);
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
        this.end = +moment(this.beginning).endOf('isoWeek');
        this.cumulativeSum = {};
        var day = moment(this.beginning);
        var sum = 0;
        while(+day < this.end){
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
            today: this.model.attributes.dataset.attributes.today,
            numDaysToShow: function() {
                return this.reversedDays().length;
            },
            reversedDays: function() {
                return _.filter([6, 5, 4, 3, 2, 1, 0], _.bind(function(i) {
                    return !this.day(i).isAfter(this.today);
                    }, this));
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
            weekNumber: function(){
                return this.self.beginning.format('W');
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
      // Implicit by setting window.dragHandler = this.
      //"mousemove": "mousemove",
      //"mouseup": "mouseup",
      "mousedown g.goal":           "mousedownGoal",
      // hover info callbacks
      "mouseover g.goal":           "mouseoverGoal",
      "mouseout g.goal":            "mouseoutGoal",
      "mouseover rect.session":     "mouseoverSession",
      "mouseout rect":              "mouseoutRect"
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
        this.weekSessions.add(newSession);
        // The view should render synchronously, so the new rect should be
        // present in the DOM if we need it.
        this.startDragging(newSession, true, event);
    },
    mousedownGoal: function(event) {
        event.preventDefault();
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
        $('#durationToolTip').css('opacity', 0);
    },
    mouseoverSession: function(event) {
        // TODO handle the case wherein we want to continue displaying the
        // tooltip despite the mouse not being over the session in question
        // (or the goal). This happens when you drag past 0 or move vertically
        // above or below the session. To draw it such that it's centered, we
        // need to know which DOM element is being dragged (so that we can
        // get its position and width), but the element appears to be nulled
        // when Marionette redraws. If we care enough to fix this, I think
        // we'll have to include drawing the tooltip in the Marionette code.
        var session = sessionForEvent(this, event);
        showToolTipForSession(session, event.target);
    },
    mouseoutRect: function(event) {
        $('#sessionToolTip').css('opacity', 0);
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

            x = event.pageX;
            y = event.pageY;

            // XXX: Ideally this time threshold would be a system setting
            // like the double-click timeout.
            if (moment().diff(dragInfo.startTime, 'milliseconds') < 300) {
                console.log('Treat as a click at position ' + x + ',' + y);
                showActivityInfo(dragInfo.session, this.updateSession.bind(this, dragInfo.session, dragInfo.isCreate));
                event.stopPropagation(); // event outside -> close popup
                return;
            }

            // if creating a session, ask for activity type and duration
            if (dragInfo.isCreate) {
                showActivityInfo(dragInfo.session, this.updateSession.bind(this, dragInfo.session, dragInfo.isCreate));
                event.stopPropagation();
                // TODO set duration to activity's current duration (some
                // default if just a click on plus) to handle both
                // click and drag cases
                return;
            }

            // Delete if duration has been reduced to zero.
            this.updateSession(dragInfo.session);
        }

        if (this.dragGoalInfo) {
            this.dragGoalInfo = null;
        }
    },
    updateSession: function(session, isCreate, isOK){
        if ((isCreate && !isOK) || session.attributes.duration == 0){
            this.weekSessions.remove(session);
        }
    }
});

var FullView = Marionette.CollectionView.extend({
    childView: WeekView,
    initialize: function() {
        window.fullView = this;  // debugging
        var dataset = this.model;
        $('#mockToday').datepicker();
        // Seems to match format generated by datepicker.
        $('#mockToday').val(dataset.attributes.today.format('L'));
        // Like WeekView.resizeCallback.  Is there a way we can use the events hash instead?
        this.changeTodayCallback = _.bind(function() {
            this.model.set('today', moment($('#mockToday').val(), 'L'));
            this.generateWeeks();
        }, this);
        $('#mockToday').on('change', this.changeTodayCallback);
        this.collection = new Backbone.Collection();
        this.generateWeeks();
    },
    remove: function() {
        $('#mockToday').off('change', this.changeTodayCallback);
        Marionette.CollectionView.prototype.remove.apply(this, arguments);
    },
    generateWeeks: function() {
        var dataset = this.model;
        var sessionsByWeek = dataset.attributes.sessions.groupBy(function(session, i) {
            return session.week();
        });
        // Ensure today is present.
        var todayWeekStr = weekFormat(moment(dataset.attributes.today).startOf('isoWeek'));
        if (!sessionsByWeek[todayWeekStr])
            sessionsByWeek[todayWeekStr] = [];
        var weekStrs = Object.keys(sessionsByWeek);
        weekStrs.sort();
        weekStrs.reverse();
        // Find shortest contiguous range of weeks containing today and all existing sessions.
        // (GR5: Allow data to be added to older weeks?)
        // XXX: Now that future days are hidden, future sessions can make the UI do various
        // weird things.  Fix this?  How?
        var m = moment(weekStrs[0]);  // weekStrs should always be nonempty because of today.
        var weekMoments = [m.clone()];
        while (weekFormat(m) > weekStrs[weekStrs.length - 1]) {
            m.subtract(1, 'week');
            weekMoments.push(m.clone());
        }
        /*
        console.log(weeks);
        for(var w in weekSessions){
            var sessions = weekSessions[w];
            console.log('%s -> %o', w, sessions);
        }
        */
        var weekModels = _.map(weekMoments, function(m) {
            return new Week({
                // If this circular reference gets us in trouble, we can find
                // another way to pass the reference to the WeekViews.
                dataset: dataset,
                beginning: m,
                sessions: new WeekSessions(sessionsByWeek[weekFormat(m)])
            });
        });
        // Re-renders everything.
        // XXX: Are there things we'd rather avoid losing by doing this more incrementally?
        this.collection.reset(weekModels);
    }
});

function sessionForEvent(ths, event) {
    var cid = $(event.target).data('cid');
    return ths.weekSessions.get(cid);
}

function showToolTipForSession(session, element) {
    var tip = $('#sessionToolTip');
    $(tip).css('opacity', 1);

    // populate tooltip, making sure not to write "Unspecified" (this is
    // ugly, and espeically ugly when the user is dragging to create a new
    // session and intends to specify something)
    var duration = session.attributes.duration;
    var durationStr = formatDuration(duration, '(Delete)');
    if (session.attributes.label == 'unspecified') {
        $(tip).html(durationStr);
    } else {
        var name = displayNameForLabel(session.attributes.label);
        $(tip).html(durationStr + ' ' + name);
    }

    // position tooltip
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
