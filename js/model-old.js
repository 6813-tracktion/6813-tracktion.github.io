
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
