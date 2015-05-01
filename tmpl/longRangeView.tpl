<script type="text/template" id="longRangeViewTpl">
  <svg width="200" height="<%= weeks.length * WEEK_HEIGHT_PX %>">
  <% weeks.each(function(week, i){ %>
  <g transform="translate(0, <%= i * WEEK_HEIGHT_PX + 1 %>)" class="day longRangeDay">
    <!-- So that hovering anywhere in the row counts as a hover on the g.day
         element, which we can check for in CSS for the bar. -->
    <rect class="background" x="0" y="0" width="200" height="<%= WEEK_HEIGHT_PX - 1 %>"/>
    <rect x="0" y="0" width="<%= Math.max(0, rm2p(week.attributes.total) - 1) %>" height="<%= WEEK_HEIGHT_PX - 1 %>"
     class="<%= totalBarClass(week) %>"/>
    <line x1="<%= rm2p(week.attributes.goal) %>" x2="<%= rm2p(week.attributes.goal) %>" y1="0" y2="<%= WEEK_HEIGHT_PX - 1 %>"
     stroke="black" stroke-width="2"/>
  </g>
  <% }) %>
  </svg>
</script>
