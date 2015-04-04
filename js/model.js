
// based on: http://tutorialzine.com/2013/04/services-chooser-backbone-js/

$(function(){

    // ================================================================
    // Session and SessionList
    // ================================================================

    var Session = Backbone.Model.extend({
        defaults: {
            day: new Date(),
            duration: 30,
            label: 'unspecified',
        },

        initialize: function () {
            console.log('initialized a session');
        }

    });

    var SessionList = Backbone.Collection.extend({
        model: Session,

        groupByDay: function() {
                return _.groupBy(data, function(item) {
                    return item.date.substring(8,10);
            });
        }

        // TODO functions to do date range query + sum over time?
    })

    var sessions = new SessionList([
        new Session({ day: "2015-04-01", duration: 60, label: 'polka'}),
        new Session({ day: "2015-04-01", duration: 100, label: 'running'}),
        new Session({ day: "2015-04-02", duration: 20, label: 'aggressive sitting'}),
        new Session({ day: "2015-04-04", duration: 40, label: 'laser tag'})
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
        },

        render: function(){
            return this;
        }
    });

    new App();
});
