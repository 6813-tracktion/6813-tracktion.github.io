
// based on: http://tutorialzine.com/2013/04/services-chooser-backbone-js/

$(function(){

    ///// UTILS ///////////////////////////////////////////////////////////////
    var dayFormat = function(m) {
        return moment(m).format('YYYY-MM-DD'); // e.g. 2015-02-15
    };
    var weekFormat = function(m) {
        // TODO: Let the user change the current goal cycle without affecting
        // past goal periods.  Can probably wait for GR5.
        return moment(m).format('GGGG-[W]W'); // e.g. 2015-W7
    };

    ///// MODEL ///////////////////////////////////////////////////////////////
    //
    var Session = Backbone.Model.extend({
        defaults: {
            date: moment(),
            duration: 30,
            label: 'unspecified',
        },
        initialize: function (attrs, options) {
            // parse date
            switch(typeof attrs.date){
                case 'number':
                case 'string':
                    attrs.date = moment(attrs.date);
                    this.attributes.date = attrs.date;
                    break;
            }
            //console.log('initialized a session');
        },
        day: function() {
            return dayFormat(this.attributes.date);
        },
        week: function() {
            return weekFormat(this.attributes.date);
        }
    });

    var WeekSessions = Backbone.Collection.extend({
        model: Session
    });

    var Week = Backbone.Model.extend({
        defaults: function() {
            return {
                sessions: new Backbone.Collection()
            };
        }
    });

    // fake model
    //
    var list = [
        new Session({ date: "2015-04-01", duration: 60,   label: 'polka'}),
        new Session({ date: "2015-04-01", duration: 100,  label: 'running'}),
        new Session({ date: "2015-04-02", duration: 20,   label: 'aggressive sitting'}),
        new Session({ date: "2015-04-04", duration: 40,   label: 'laser tag'})
    ];
    for(var i = 0; i < 100; ++i){
        var m = moment("2015-04-04")
                  .subtract(Math.round(i / 3 + Math.random() * i), 'days')
                  .add(Math.round(Math.random() * 1e6), 'ms');
        list.push(new Session({ date: m, duration: Math.ceil(1 + Math.random() * 10) * 5, label: 'random'}));
    }
    list.sort(function(a, b){
        return moment(a.attributes.date) - moment(b.attributes.date) < 0;
    });
    var sessions = new Backbone.Collection(list);

    //////////////////
    // Marionette code
    //////////////////

    // @see http://jsfiddle.net/bryanbuchs/c72Vg/
    var WeekView = Marionette.ItemView.extend({
        template: "#weekTpl",
        initialize: function(options) {
            this.weekSessions = this.model.attributes.sessions;
            this.listenTo(this.weekSessions, 'add', this.render);
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
          "click rect.new-session": "createSession",
          "click rect.session":     "updateSession"
        },
        createSession: function(event){
            var day = $(event.target).data('day');
            console.log('Yo! day=%d, event=%o', day, event);
            // TODO: Let the user input the parameters.
            var date = this.templateHelpers().day(day);
            var s = new Session({date: date, duration: 30});
            this.weekSessions.add(s);
        },
        updateSession: function(event){
            var day = $(event.target).data('day');
            var index = $(event.target).data('day-index');
            console.log('Yosh! day=%d, index=%d', day, index);
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

    // application
    //
    var app = new Marionette.Application();
    app.addRegions({
        weekList: '#weeks'
    });
    app.on('start', function(options){
        console.log('Started Marionette application, options = %o', options);

        if(Backbone.history){
            Backbone.history.start();
        }
    });

    app.weekList.show(new FullView({collection: sessions}));

    app.start();
});
