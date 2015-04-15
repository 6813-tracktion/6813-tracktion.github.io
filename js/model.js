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
            goal: 200,
            sessions: new Backbone.Collection()
        };
    }
});

function loadFreshModel() {
    var list = [
        new Session({ date: "2015-04-01", duration: 60,   label: 'running'}),
    ];
    var sessions = new Backbone.Collection(list);
    // var sessions = new Backbone.Collection([]);
    return sessions;
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
    return sessions;
}
