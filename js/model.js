/**
 * Model-related functions
 */

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
            dataset: null,  // Required reference to DataSet.
            beginning: moment('2015-04-13'),
            goal: 200,
            sessions: new Backbone.Collection()
        };
    },
    initialize: function() {
        // Propagate additions/removals back to the master sessions collection.
        // This will need to change if we allow a session to be dragged to a different goal period.
        this.listenTo(this.attributes.sessions, 'add', function(session) {
            this.attributes.dataset.attributes.sessions.add(session);
            });
        this.listenTo(this.attributes.sessions, 'remove', function(session) {
            this.attributes.dataset.attributes.sessions.remove(session);
            });
    }
});

// A temporary data structure, but still gives us a way to pass in the current day.
var DataSet = Backbone.Model.extend({
    defaults: function() {
        return {
            today: moment().startOf('isoWeek'),
            sessions: new Backbone.Collection()
        };
    }
});

function loadFreshModel() {
    var sessions = new Backbone.Collection([]);
    return new DataSet({today: moment('2015-04-04'), sessions: sessions});
}

function loadModel(){
    // fake model
    //
    var list = [
        new Session({ date: "2015-04-01", duration: 60,   label: 'polka'}),
        new Session({ date: "2015-04-01", duration: 100,  label: 'running'}),
        new Session({ date: "2015-04-02", duration: 30,   label: 'sitting'}),
        new Session({ date: "2015-04-04", duration: 40,   label: 'swimming'})
    ];
    var labels = Object.keys(DEFAULT_ACTIVITY_TYPES);
    for(var i = 0; i < 100; ++i){
        var m = moment("2015-04-04")
              .subtract(7 + Math.round(i / 3 + Math.random() * i), 'days')
              .add(Math.round(Math.random() * 1e6), 'ms');
        var label = labels[Math.floor(Math.random() * (labels.length + 1))] || 'random';
        list.push(new Session({ date: m, duration: Math.ceil(1 + Math.random() * 10) * 5, label: label}));
    }
    list.sort(function(a, b){
        return moment(a.attributes.date) - moment(b.attributes.date) < 0;
    });
    var sessions = new Backbone.Collection(list);
    return new DataSet({today: moment('2015-04-04'), sessions: sessions});
}
