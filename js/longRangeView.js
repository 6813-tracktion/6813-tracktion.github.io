var LongRangeView = Marionette.ItemView.extend({
    template: '#longRangeViewTpl',
    initialize: function(options) {
        this.throttledRender = _.throttle(this.render, 100);
        this.listenTo(this.model.attributes.weeks, 'add change:goal change:total remove reset', this.throttledRender);
    },
    templateHelpers: function() {
        // Do this computation only once per render.
        var maxMinutes = Math.max(420,
                _.max(this.model.attributes.weeks.pluck('total')),
                _.max(this.model.attributes.weeks.pluck('goal')));
        var PX_PER_MIN = (198 /*total usable width*/ / maxMinutes);
        var maxTicks = 5;
        // Choose an integer number of hours at which we can draw a tick.
        var hoursPerTick = Math.floor(maxMinutes / 60 / (maxTicks+1)) + 1;
        return {
            WEEK_HEIGHT_PX: 13,
            PX_PER_MIN: PX_PER_MIN,
            maxMinutes: maxMinutes,
            hoursPerTick: hoursPerTick,
            // Round so our 1px borders are aligned with the screen pixels.
            rm2p: function(min) {
                return Math.round(this.PX_PER_MIN * min);
            },
            totalBarClass: function(week) {
                return (week.attributes.total >= week.attributes.goal ?
                        "longRangeBarComplete" : "longRangeBarIncomplete");
            }
        };
    },
    events: {
        "click g.longRangeWeek": "jumpToWeek",
    },
    jumpToWeek: function(event) {
        var cid = $(event.currentTarget).data('cid');
        window.scrollToWeek(this.model.attributes.weeks.get(cid));
    }
});
