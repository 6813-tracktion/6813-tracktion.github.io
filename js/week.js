/**
 * Week-related views
 */

var DURATION_GRANULARITY = 5;

var DAY_HEIGHT_PX = 42;  // Keep in sync with svg {...} in main.css
var PX_PER_MIN = 700 / 420;

// @see http://jsfiddle.net/bryanbuchs/c72Vg/
var WeekView = Marionette.ItemView.extend({
    template: "#weekTpl",
    initialize: function(options) {
        this.weekSessions = this.model.attributes.sessions;
        this.listenTo(this.weekSessions, 'add', this.render);
        this.listenTo(this.weekSessions, 'change', this.render);
        this.listenTo(this.weekSessions, 'remove', this.render);
        this.dragInfo = null;
    },
    onBeforeRender: function() {
        this.byDay = this.weekSessions.groupBy(function(session, i) {
            return session.day();
        });
        // cache
        this.beginning = moment(this.weekSessions.at(0).attributes.date).startOf('isoWeek');
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
            attr: function(session, name){
                return session.attributes[name];
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
            }
        };
    },
    events: {
      "mousedown rect.session":     "mousedownSession",
      "mousedown rect.new-session": "mousedownPlus",
      "mousemove": "mousemove",
      "mouseup": "mouseup",
    },
    mousedownSession: function(event){
        var cid = $(event.target).data('cid');
        this.startDragging(this.weekSessions.get(cid), false, event);
    },
    mousedownPlus: function(event){
        var day = $(event.target).data('day');
        var date = this.templateHelpers().day(day);
        var newSession = new Session({date: date});
        this.weekSessions.add(newSession);
        // The view should render synchronously, so the new rect should be
        // present in the DOM if we need it.
        this.startDragging(newSession, true, event);
    },
    startDragging: function(session, isCreate, event){
        this.dragInfo = {
                session: session,
                isCreate: isCreate,
                startTime: moment(),
                origDuration: session.attributes.duration,
                origMouseX: event.pageX
        };
        $('body').addClass('dragging');
    },
    mousemove: function(event){
        if (this.dragInfo) {
            var newDuration = Math.max(0,
                    this.dragInfo.origDuration +
                    (event.pageX - this.dragInfo.origMouseX) / PX_PER_MIN);
            newDuration = DURATION_GRANULARITY * Math.round(newDuration / DURATION_GRANULARITY);
            this.dragInfo.session.set('duration', newDuration);
        }
    },
    mouseup: function(event){
        if (this.dragInfo) {
            x = event.pageX;
            y = event.pageY;

            // XXX: Ideally this time threshold would be a system setting
            // like the double-click timeout.
            if (moment().diff(this.dragInfo.startTime, 'milliseconds') < 300) {
                console.log('Treat as a click at position ' + x + ',' + y);
                // showActivityInfoAtPosition(x, y);
                showActivityInfo(x, y, function() {
                    console.log('way to edit activity, bro');
                });
                event.stopPropagation(); // event outside -> close popup
            }

            // if creating a session, ask for activity type and duration
            if (this.dragInfo.isCreate) {
                showActivityInfo(x, y, function() {
                    console.log('way to edit activity, bro');
                });
                event.stopPropagation();
                // TODO set duration to activity's current duration (some
                // default if just a click on plus) to handle both
                // click and drag cases
            }

            // Delete if duration has been reduced to zero.
            if (this.dragInfo.session.attributes.duration == 0)
                this.weekSessions.remove(this.dragInfo.session);
            this.dragInfo = null;
            $('body').removeClass('dragging');
        }
    }
});

var FullView = Marionette.CollectionView.extend({
    childView: WeekView,
    initialize: function() {
        var sessionsByWeek = this.collection.groupBy(function(session, i) {
            return session.week();
        });
        /*
        var weeks = Object.keys(weekSessions);
        console.log(weeks);
        for(var w in weekSessions){
            var sessions = weekSessions[w];
            console.log('%s -> %o', w, sessions);
        }
        */
        var weeks = _.map(sessionsByWeek, function(weekSessionsArray) {
            return new Week({sessions: new WeekSessions(weekSessionsArray)});
        });
        this.collection = new Backbone.Collection(weeks);
    }
});
