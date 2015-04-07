
// based on: http://tutorialzine.com/2013/04/services-chooser-backbone-js/

$(function(){

    // ================================================================
    // Session and SessionList
    // ================================================================

    var Session = Backbone.Model.extend({
        defaults: {
            date: moment(),
            duration: 30,
            label: 'unspecified',
        },

        initialize: function () {
            // parse date
            switch(typeof this.date){
                case 'number':
                case 'string':
                    this.date = moment(this.date);
                    break;
            }
            console.log('initialized a session');
        },

        day: function() {
            return moment(this.date).format('YYYY-MM-DD'); // e.g. 2015-02-15
        },

        week: function() {
            return moment(this.date).format('YYYY-[W]W'); // e.g. 2015-W7
        }

    });

    var SessionList = Backbone.Collection.extend({
        model: Session,

        groupByDay: function() {
            return this.groupBy(function(session) {
                return session.day();
            });
        },

        groupByWeek: function() {
            return this.groupBy(function(session) {
                return session.week();
            });
        }

        // TODO functions to do date range query + sum over time?
    });

    var sessions = new SessionList([
        new Session({ date: "2015-04-01", duration: 60,   label: 'polka'}),
        new Session({ date: "2015-04-01", duration: 100,  label: 'running'}),
        new Session({ date: "2015-04-02", duration: 20,   label: 'aggressive sitting'}),
        new Session({ date: "2015-04-04", duration: 40,   label: 'laser tag'})
    ]);

    // ================================================================
    // View class
    // ================================================================

    var SessionView = Backbone.View.extend({
        tagName: 'li',

        events:{
            'click': 'receivedClick'
        },

        initialize: function() {
            // whenever a property changes, re-render
            this.listenTo(this.model, 'change', this.render);
        },

        render: function(){
            // Create the HTML
            this.$el.html('<span style="color: green">' + this.model.get('label') + ' for ' + this.model.get('duration') + 'min');
            return this;
        },

        receivedClick: function() {
            alert('Y u click ' + this.model.get('label') + '!?');
        }
    });

    // ================================================================
    // App class
    // ================================================================

    var App = Backbone.View.extend({
        // Base the view on an existing element
        el: $('#sessions'),

        initialize: function(){

            // Cache these selectors
            this.total = $('#totalMinutes');
            this.list = $('#sessionsList');

            // Listen for the change event on the collection.
            // This is equivalent to listening on every one of the
            // service objects in the collection.
            this.listenTo(sessions, 'change', this.render);

            // create a list item for each session
            sessions.each(function(session) {
                var view = new SessionView({model: session});
                this.list.append(view.render().el);

            }, this);   // "this" is the context in the callback

            // display total minutes
            var totalMins = 0;
            sessions.each(function(elem){
                totalMins += elem.get('duration');
                console.log('adding up a session');
            });

            this.total.html(totalMins + ' minutes');

            // Note from Alex:
            // - currently nothing here uses Marionette
            // - d3 is declarative, so it's going to be harder to use templates (and Marionette)

        },

        render: function(){
            return this;
        }
    });

    new App();

});

$(function(){

    ///// UTILS ///////////////////////////////////////////////////////////////
    var dayFormat = function(m) {
        return moment(m).format('YYYY-MM-DD'); // e.g. 2015-02-15
    };
    var weekFormat = function(m) {
        return moment(m).format('YYYY-[W]W'); // e.g. 2015-W7
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
                    break;
            }
            console.log('initialized a session');
        },
        day: function() {
            return dayFormat(this.attributes.date);
        },
        week: function() {
            return weekFormat(this.attributes.date);
        }
    });

    // fake model
    //
    var sessions = new Backbone.Collection([
        new Session({ date: "2015-04-01", duration: 60,   label: 'polka'}),
        new Session({ date: "2015-04-01", duration: 100,  label: 'running'}),
        new Session({ date: "2015-04-02", duration: 20,   label: 'aggressive sitting'}),
        new Session({ date: "2015-04-04", duration: 40,   label: 'laser tag'})
    ]);

    //////////////////
    // Marionette code
    //////////////////

    // @see http://jsfiddle.net/bryanbuchs/c72Vg/
    var WeekView = Marionette.ItemView.extend({
        template: "#weekTpl",
        initialize: function(options) {
            this.weekSessions = new Backbone.Collection(_.toArray(this.model.attributes));
            this.byDay = this.weekSessions.groupBy(function(session, i) {
                return session.day();
            });
            // cache
            this.beginning = moment(this.model.attributes[0].attributes.date).startOf('week');
            this.end = +moment(this.beginning).endOf('week');
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
            
            // binding
            this.templateHelpers.self = this;
        },
        templateHelpers: {
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
            weekNumber: function(data){
                if(data.length)
                    return data[0].week();
                else
                    return -1;
            }
        },
        events: {
          "click rect.new-session": "createSession",
          "click rect.session":     "updateSession"
        },
        createSession: function(event){
            var day = $(event.target).data('day');
            console.log('Yo! day=%d, event=%o', day, event);
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
            var weekSessions = this.collection.groupBy(function(session, i) {
                return session.week();
            });
            this.collection = new Backbone.Collection(_.toArray(weekSessions));
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
