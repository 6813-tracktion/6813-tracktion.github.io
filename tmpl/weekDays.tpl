
<script type="text/template" id="weekDays">
<g class="days">
<% _.each(reversedDays(), function(d, i) { %>
  <g transform="translate(0, <%= i * DAY_HEIGHT_PX + 1 %>)" class="day">
    <!-- background for row hover -->
    <rect class="background" height="<%= DAY_HEIGHT_PX %>" width="800" />
    <g transform="translate(100, 0)" class="sessions">
      <!-- cumulative fill -->
      <!-- IMO, filling under the cumulative graph is misleading because
           the area under it doesn't have any meaning. -->
      <!--<rect class="cumulative" height="<%= DAY_HEIGHT_PX %>" width="<%= rm2p(cumulative(d)) %>" />-->
      <circle class="cumulative" cy="<%= DAY_HEIGHT_PX/2 %>" cx="<%= rm2p(cumulative(d)) %>" r="5" />
      <!--
      <text class="cumulative" y="<%= DAY_HEIGHT_PX/2 %>" x="<%= rm2p(cumulative(d)) + 20 %>" dy=".35em"><%= cumulative(d) %></text>
      -->

      <!-- activity slots -->
      <% _.each(daySessions(d), function(session, j){ %>
        <g transform="translate(<%= rm2p(daySum(d, j)) %>, 0)"> 
          <rect class="session" height="<%= DAY_HEIGHT_PX-1 %>" width="<%= rm2p(attr(session, 'duration')) - 1 %>" data-cid="<%= session.cid %>"  />
          <image xlink:href="<%= iconURL(session)  %>" x="20" width="32" height="32" y="5" />
        </g>
      <% }) %>
      <% if(emptyDay(d)){ %>
        <!-- lazy boy -->
      <% } %>
      <!-- new session button and sum text -->
      <g transform="translate(<%= rm2p(daySum(d)) %>, 0)">
        <rect class="new-session" height="<%= DAY_HEIGHT_PX-1 %>" width="<%= DAY_HEIGHT_PX-1 %>" data-day="<%= d %>" />
        <line class="new-session" x1="<%= DAY_HEIGHT_PX/2 %>" x2="<%= DAY_HEIGHT_PX/2 %>" y1="<%= 1/6*DAY_HEIGHT_PX %>" y2="<%= 5/6*DAY_HEIGHT_PX %>" />
        <line class="new-session" y1="<%= DAY_HEIGHT_PX/2 %>" y2="<%= DAY_HEIGHT_PX/2 %>" x1="<%= 1/6*DAY_HEIGHT_PX %>" x2="<%= 5/6*DAY_HEIGHT_PX %>" />
        <text x="49" y="<%= DAY_HEIGHT_PX/2 %>" dy=".35em" class="day-sum"><%= daySum(d) %></text>
      </g>
    </g>
    <text x="10" y="<%= DAY_HEIGHT_PX/2 %>" dy=".35em" class="day"><%= day(d).format("MMMM DD")%></text>
  </g>
<% }) %>
<line x1="100" x2="100" y1="0" y2="<%= 7*DAY_HEIGHT_PX %>" class="separator" />
</g>
</script>
