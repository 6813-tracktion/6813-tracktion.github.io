var LongRangeView = Marionette.ItemView.extend({
    template: '#longRangeViewTpl',
    initialize: function(options) {
        this.throttledRender = _.throttle(this.render, 100);
        this.listenTo(this.model.attributes.weeks, 'add change:goal change:total remove reset', this.throttledRender);
    },
    templateHelpers: function() {
        return {
            WEEK_HEIGHT_PX: 13,
            // Do this computation only once per render.
            PX_PER_MIN: (200 /*total width*/ / Math.max(420, _.max(this.model.attributes.weeks.pluck('total')))),
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
