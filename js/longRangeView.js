var LongRangeView = Marionette.ItemView.extend({
    template: '#longRangeViewTpl',
    initialize: function(options) {
        this.throttledRender = _.throttle(this.render, 100);
        this.listenTo(this.model.attributes.weeks, 'add change:goal change:total remove reset', this.throttledRender);
    },
    // TODO
    templateHelpers: function() {
        return {
            WEEK_HEIGHT_PX: 13,
            // Do this computation only once per render.
            PX_PER_MIN: (200 /*total width*/ / Math.max(420, _.max(this.model.attributes.weeks.pluck('total')))),
            // Round so our 1px borders are aligned with the screen pixels.
            rm2p: function(min) {
                return Math.round(this.PX_PER_MIN * min);
            },
            totalBarStyle: function(week) {
                // Colors copied from week.js, but lighter to make the goal line easier to see.
                return week.attributes.total >= week.attributes.goal ? "fill:rgba(0,150,0,0.5);":"fill:rgba(227,227,22,0.5);";
            }
        };
    }
});
