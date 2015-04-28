
<script type="text/template" id="weekDays">
<g class="days">
<% _.each(reversedDays(), function(d, i) { %>
  <g transform="translate(0, <%= i * DAY_HEIGHT_PX + 1 %>)" class="day">
    <!-- background for row hover -->
    <rect class="background" height="<%= DAY_HEIGHT_PX %>" width="800" />
    <g transform="translate(100, 0)" class="sessions">

      <!-- activity slots -->
      <% _.each(daySessions(d), function(session, j){ %>
        <g class="session" transform="translate(<%= rm2p(daySum(d, j)) %>, 0)">
          <rect class="session <%= sessionClass(session) %>" height="<%= DAY_HEIGHT_PX-1 %>" width="<%= rm2p(attr(session, 'duration')) - 1 %>" data-cid="<%= session.cid %>"  />
          <% if(attr(session, 'duration') >= 30){ %>
            <image xlink:href="<%= iconURL(session) %>" class="<%= iconClass(session) %>" x="10" width="32" height="32" y="5" />
          <% } %>
          <% if(urlVar('splitter') == 'true'){ %>
            <image xlink:href="img/splitter2.png" class="splitter" x="<%= rm2p(attr(session, 'duration')) - 24 %>" width="24" height="32" y="5" />
          <% } else if(urlVar('splitter') == 'lines') { %>
            <g transform="translate(<%= rm2p(attr(session, 'duration')) %>, 0)">
              <line class="splitter" x1="-6" x2="-6" y1="<%= DAY_HEIGHT_PX / 6.0 %>" y2="<%= DAY_HEIGHT_PX*5.0/6.0 %>" />
              <line class="splitter" x1="-9" x2="-9" y1="<%= DAY_HEIGHT_PX / 6.0 %>" y2="<%= DAY_HEIGHT_PX*5.0/6.0 %>" />
            </g>
          <% } %>
        </g>
      <% }) %>
      <% if(emptyDay(d)){ %>
        <!-- lazy boy -->
      <% } %>
      <!-- new session button and sum text -->
      <g transform="translate(<%= rm2p(daySum(d)) %>, 0)">
        <!-- plus button -->
        <g transform="translate(1, <%= DAY_HEIGHT_PX/6 %>)">
          <g transform="scale(<%= DAY_HEIGHT_PX*2/3 %>) translate(0.5, 0.5)" stroke-width="0.1">
          <% if(urlVar('plus') == 'rounded'){ %>
            <rect class="new-session" x="-0.5" y="-0.5" rx="0.1" height="1" width="1" data-day="<%= d %>" />
          <% } else if(urlVar('plus') == 'special'){ %>
            <!-- @see http://www.w3.org/TR/SVG/shapes.html#RectElement and http://www.w3.org/TR/SVG/paths.html#PathElement -->
            <path class="new-session"
                  d="M-0.5,-0.5
                     L0.3,-0.5
                     A0.2,0.2 0 0,1 0.5,-0.3
                     L0.5,0.3
                     A0.2,0.2 0 0,1 0.3,0.5
                     L-0.5,0.5
                     L-0.5,-0.5
                     Z
                    " data-day="<%= d %>" />
          <% } else { %>
            <rect class="new-session" x="-0.5" y="-0.5" height="1" width="1" data-day="<%= d %>" />
          <% } %>
            <line class="new-session" x1="0" x2="0" y1="-0.2" y2="0.2" />
            <line class="new-session" y1="0" y2="0" x1="-0.2" x2="0.2" />
          </g>
        </g>
        <!-- day sum -->
        <text x="49" y="<%= DAY_HEIGHT_PX/2 %>" dy=".35em" class="day-sum"><%= formatDuration(daySum(d), '0') %></text>
      </g>
    </g>
    <!-- day label -->
  <% if (day(d).isSame(today)) { %>
    <text x="88" y="<%= DAY_HEIGHT_PX/2 %>" dy="5px" text-anchor="end" class="day today">Today</text>
  <% } else { %>
    <text x="88" y="<%= DAY_HEIGHT_PX/2 %>" dy=".33em" text-anchor="end" class="day"><%= day(d).format("ddd M/D")%> </text>    
  <% } %>
  </g>
<% }) %>
<line x1="100" x2="100" y1="-100" y2="<%= 10*DAY_HEIGHT_PX %>" class="separator" />
</g>
</script>
