<script type="text/template" id="longRangeViewTpl">
  <svg width="200" height="<%= 21 + weeks.length * WEEK_HEIGHT_PX %>"><g transform="translate(1,21)">
  <% for (var i = 1; 60*i*hoursPerTick <= maxMinutes; i++) { %>
    <line x1="<%= rm2p(60*i*hoursPerTick) %>" x2="<%= rm2p(60*i*hoursPerTick) %>" y1="-7" y2="-2" stroke="black" stroke-width="2px"/>
    <text style="text-anchor: middle;" x="<%= rm2p(60*i*hoursPerTick) %>" y="-10"><%= i*hoursPerTick %>h</text>
  <% } %>
  <!-- Leave 2px vertical margin before the first week row so the goal mark
       doesn't join the axis. -->
  <line x1="-1" x2="199" y1="-2" y2="-2" stroke="black" stroke-width="2px"/>
  <% weeks.each(function(week, i){ %>
  <g transform="translate(0, <%= i * WEEK_HEIGHT_PX + 1 %>)" class="longRangeWeek" data-cid="<%= week.cid %>">
    <!-- So that hovering anywhere in the row counts as a hover on the g.day
         element, which we can check for in CSS for the bar. -->
    <rect class="background" x="0" y="0" width="200" height="<%= WEEK_HEIGHT_PX - 1 %>"/>
    <rect x="0" y="0" width="<%= Math.max(0, rm2p(week.attributes.total) - 1) %>" height="<%= WEEK_HEIGHT_PX - 1 %>"
     class="<%= totalBarClass(week) %>"/>
    <line x1="<%= rm2p(week.attributes.goal) %>" x2="<%= rm2p(week.attributes.goal) %>" y1="0" y2="<%= WEEK_HEIGHT_PX - 1 %>"
     stroke="black" stroke-width="2"/>
  </g>
  <% }) %>
  <line class="separator" x1="0" x2="0" y1="-7" y2="<%= weeks.length * WEEK_HEIGHT_PX %>"/>
  </g></svg>
</script>
