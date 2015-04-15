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
        // http://stackoverflow.com/questions/14460855/backbone-js-listento-window-resize-throwing-object-object-has-no-method-apply
        this.resizeCallback = _.bind(this.fixSVGFractionalCoordinates, this);
        $(window).on('resize', this.resizeCallback);
    },
    remove: function() {
        $(window).off('resize', this.resizeCallback);
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
            this.$('svg').attr('style', 'position: relative; ' +
                    'top: ' + -(ctm.f % 1) + 'px; left: ' + -(ctm.e % 1) + 'px;');
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
            days: function() {
                return [0, 1, 2, 3, 4, 5, 6];
            },
            reversedDays: function() {
                return [6, 5, 4, 3, 2, 1, 0];
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
                showActivityInfo(dragInfo.session, this.updateSession.bind(this, dragInfo.session));
                event.stopPropagation(); // event outside -> close popup
                return;
            }

            // if creating a session, ask for activity type and duration
            if (dragInfo.isCreate) {
                showActivityInfo(dragInfo.session, this.updateSession.bind(this, dragInfo.session));
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
    updateSession: function(session){
        if (session.attributes.duration == 0){
            this.weekSessions.remove(session);
        }
    }
});

var FullView = Marionette.CollectionView.extend({
    childView: WeekView,
    initialize: function() {
        var dataset = this.model;
        var sessionsByWeek = dataset.attributes.sessions.groupBy(function(session, i) {
            return session.week();
        });
        // Ensure today is present.
        var todayWeekStr = weekFormat(dataset.attributes.today.startOf('isoWeek'));
        if (!sessionsByWeek[todayWeekStr])
            sessionsByWeek[todayWeekStr] = [];
        var weekStrs = Object.keys(sessionsByWeek);
        weekStrs.sort();
        weekStrs.reverse();
        // Find shortest contiguous range of weeks containing today and all existing sessions.
        // (GR5: Allow data to be added to older weeks?)
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
                beginning: m,
                today: dataset.attributes.today,
                sessions: new WeekSessions(sessionsByWeek[weekFormat(m)])
            });
        });
        this.collection = new Backbone.Collection(weekModels);
    }
});
