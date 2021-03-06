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

// TODO: Rename to goal period
var Week = Backbone.Model.extend({
    defaults: function() {
        return {
            dataset: null,  // Required reference to DataSet.
            beginning: moment('2015-04-13'),
            end: moment('2015-04-19'),  // Inclusive for our convenience.
            goal: 200,
            total: null,  // Computed field
            canChangeEnd: null,  // Computed field
            sessions: null,  // Set by initialize; should not be passed by the caller.
        };
    },
    initialize: function() {
        var sessions = new FilteredCollection(this.attributes.dataset.attributes.sessions);
        this.set('sessions', sessions, {silent: true});
        sessions.filterBy('thisWeek', _.bind(function(sess) {
            return !sess.attributes.date.isBefore(this.attributes.beginning) &&
                !sess.attributes.date.isAfter(this.attributes.end);
        }, this));
        this.listenTo(this, 'change:beginning', function() { sessions.refilter(); });
        this.listenTo(this, 'change:end', function() { sessions.refilter(); });
        this.listenTo(this.attributes.sessions, 'add change remove reset', this.updateTotal);
        this.updateTotal();
        this.listenTo(this.attributes.dataset.attributes.weeks, 'add sort remove reset', this.updateCanChangeEnd);
        this.updateCanChangeEnd();
    },
    // https://github.com/alexbeletsky/backbone-computedfields is a good library
    // but not worth the trouble for this.
    updateTotal: function() {
        var total = 0;
        _.each(this.attributes.sessions.pluck('duration'), function(d) { total += d; });
        this.set('total', total);
    },
    updateCanChangeEnd: function() {
        var index = this.attributes.dataset.attributes.weeks.indexOf(this);
        this.set('canChangeEnd', index == 0 || index == 1);
    }
});

var DataSet = Backbone.Model.extend({
    defaults: function() {
        return {
            today: moment().startOf('day'),
            sessions: new Backbone.Collection(),
            // In reverse order because it's awkward to reverse in the view. :/
            weeks: new Backbone.Collection()
        };
    },
    initialize: function() {
        var weeks = this.attributes.weeks;
        if (weeks.length == 0) {
            var beginning = this.attributes.today;
            weeks.add(new Week({
                dataset: this,
                beginning: beginning,
                end: moment(beginning).startOf('isoWeek').add(6, 'days'),
            }));
        } else {
            this.extendToToday();
        }
        this.listenTo(this, 'change:today', this.extendToToday);
        // In case the last week (first in the collection) is changed to end in the past.
        this.listenTo(weeks, 'change:end', this.extendToToday);
    },
    extendToToday: function() {
        var weeks = this.attributes.weeks, lastWeek = weeks.at(0);
        while (lastWeek.attributes.end.isBefore(this.attributes.today)) {
            lastWeek = weeks.unshift(new Week({
                dataset: this,
                beginning: moment(lastWeek.attributes.end).add(1, 'days'),
                end: moment(lastWeek.attributes.end).add(7, 'days'),
                goal: lastWeek.attributes.goal,
            }));
        }
    }
});

function loadFreshModel() {
    var sessions = new Backbone.Collection([]);
    return new DataSet({today: moment(getUrlParameter('today') || '2015-03-30'), sessions: sessions});
}

function loadModel(){
    // fake model
    //
    var list = [
        new Session({ date: "2015-03-30", duration: 30,   label: 'running'}),
        new Session({ date: "2015-04-01", duration: 60,   label: 'polka'}),
        new Session({ date: "2015-04-01", duration: 50,   label: 'running'}),
        new Session({ date: "2015-04-02", duration: 45,   label: 'sitting'}),
        new Session({ date: "2015-04-04", duration: 40,   label: 'swimming'})
    ];
    var labels = Object.keys(DEFAULT_ACTIVITY_TYPES);
    for(var i = 0; i < 100; ++i){
        var m = moment("2015-04-04")
              .subtract(7 + Math.round(i / 3 + Math.random() * i), 'days');
        var label = labels[Math.floor(Math.random() * labels.length)];
        list.push(new Session({ date: m, duration: Math.ceil(1 + Math.random() * 10) * 5, label: label}));
    }
    list.sort(function(a, b){
        return moment(a.attributes.date).diff(moment(b.attributes.date));
    });
    var sessions = new Backbone.Collection(list);
    var dataset = new DataSet({today: moment('2015-04-04'), sessions: sessions});
    dataset.attributes.weeks.at(0).set('beginning', moment('2015-03-30'));
    dataset.attributes.weeks.at(0).set('goal', 270);

    // Generate goal periods to cover all possible randomly generated sessions.
    var weekStart = moment("2015-03-23");
    var g = 260;
    while (!weekStart.isBefore(moment("2014-11-10"))) {
        dataset.attributes.weeks.add(new Week({
            dataset: dataset,
            beginning: moment(weekStart),
            end: moment(weekStart).add(6, 'days'),
            goal: g,
        }));
        weekStart.subtract(1, 'weeks');
        g -= 10;
    }

    return dataset;
}
