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
        "click g.longRangeWeek":        "jumpToWeek",
        "mouseover g.longRangeWeek":    "mouseoverHistoryBar"
    },
    jumpToWeek: function(event) {
        var cid = $(event.currentTarget).data('cid');
        window.scrollToWeek(this.model.attributes.weeks.get(cid));
    },
    mouseoverHistoryBar: function(event) {
        var weeks = this.model.attributes.weeks;
        var cid = $(event.currentTarget).data('cid');
        showToolTipForWeek(weeks.get(cid), event.target);
    },
    mouseoutHistoryBar: function(event) {
        hideTooltipForWeek();
    }
});

function showToolTipForWeek(week, element) {
    var attrs = week.attributes;

    var beginStr = attrs.beginning.format("M/D");
    var endStr = attrs.end.format("M/D");
    var totalStr = formatDuration(attrs.total);
    var goalStr = formatDuration(attrs.goal);
    var success = attrs.total > attrs.goal;
    var content = '<p class="historyWeekTitle">' + beginStr + '–' + endStr + ':</p>';
    if (success) {
        content += '<p class="historyWeekProgress success">Success!</p>';
        content += '<p class="historyWeekProgress">Did ';
    } else {
        content += '<p class="historyWeekProgress failure">Failure</p>';
        content += '<p class="historyWeekProgress">Only did ';
    }
    content += totalStr + ' out of ' + goalStr + '</p>';

    var tip = $('#historyToolTip');
    $(tip).css('opacity', 1);
    $(tip).html(content);

    moveToElementPlusOffset(tip, element, 215, -26);
}

function hideTooltipForWeek() {
    $('#historyToolTip').css('opacity', 0);
}
