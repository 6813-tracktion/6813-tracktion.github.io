
<script type="text/template" id="weekDays">
<g class="days">
<% _.each(reversedDays(), function(d, i) { %>
  <g transform="translate(0, <%= i * DAY_HEIGHT_PX + 1 %>)" class="day">
    <!-- background for row hover -->
    <rect class="background" height="<%= DAY_HEIGHT_PX %>" width="800" />
    <g transform="translate(100, 0)" class="sessions">

      <!-- activity slots -->
      <% _.each(daySessions(d), function(session, j){ %>
        <g transform="translate(<%= rm2p(daySum(d, j)) %>, 0)">
          <rect class="session <%= sessionClass(session) %>" height="<%= DAY_HEIGHT_PX-1 %>" width="<%= rm2p(attr(session, 'duration')) - 1 %>" data-cid="<%= session.cid %>"  />
          <% if(attr(session, 'duration') >= 30){ %>
          <image xlink:href="<%= iconURL(session) %>" class="<%= iconClass(session) %>" x="10" width="32" height="32" y="5" />
          <% } %>
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
    <% if (day(d).isSame(today)) { %>
      <!-- 1 line version -->
      <text x="88" y="<%= DAY_HEIGHT_PX/2 %>" dy="4px" text-anchor="end" class="day today">Today <%= day(d).format("MMM D")%></text>
      <!-- 2 line version -->
      <!-- <text x="92" y="<%= DAY_HEIGHT_PX/2 - 18%>" dy=".35em" text-anchor="end" class="day today">Today,</text>
      <text x="88" y="<%= DAY_HEIGHT_PX/2 %>" dy=".35em" text-anchor="end" class="day today"><%= day(d).format("MMM D")%></text>-->
    <% } else { %>
      <text x="88" y="<%= DAY_HEIGHT_PX/2 %>" dy=".33em" text-anchor="end" class="day"><%= day(d).format("MMM D")%> </text>
    <% } %>
  </g>
<% }) %>
<line x1="100" x2="100" y1="-100" y2="<%= 10*DAY_HEIGHT_PX %>" class="separator" />
</g>
</script>
