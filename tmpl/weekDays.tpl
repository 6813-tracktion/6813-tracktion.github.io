
<script type="text/template" id="weekDays">
<defs>
  <linearGradient id="Gradient<%= weekNumber() %>">
    <stop offset="0"    stop-color="white" stop-opacity="1" />
    <stop offset="0.7"  stop-color="white" stop-opacity="0.8" />
    <stop offset="0.8"  stop-color="white" stop-opacity="0.2" />
    <stop offset="0.9"  stop-color="white" stop-opacity="0" />
  </linearGradient>
  <mask id="Mask<%= weekNumber() %>" maskUnits="userSpaceOnUse"
      x="-30" y="0" width="62" height="<%= DAY_HEIGHT_PX %>">
    <rect x="-40" y="0" width="62" height="<%= DAY_HEIGHT_PX %>" fill="url(#Gradient<%= weekNumber() %>)"  />
  </mask>
</defs>
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
          <!-- activity image -->
          <g transform="translate(3, 5)">
            <% if(attr(session, 'duration') >= 30){ %>
              <image xlink:href="<%= iconURL(session) %>" class="<%= iconClass(session) %>" x="0" width="32" height="32" y="0" />
            <% } else { %>
              <!-- masked image with fading -->
              <g transform="translate(<%= rm2p(attr(session, 'duration')) - 30 %>, 0)" mask="url(#Mask<%= weekNumber() %>)" >
                <image xlink:href="<%= iconURL(session) %>" class="<%= iconClass(session) %>" x="<%= 30 - rm2p(attr(session, 'duration')) %>" width="32" height="32" y="0" />
              </g>
            <% } %>
          </g>
          <!-- drag affordance -->
          <g transform="translate(<%= rm2p(attr(session, 'duration')) %>, 0)">
            <line class="splitter" x1="-6" x2="-6" y1="<%= DAY_HEIGHT_PX / 6.0 %>" y2="<%= DAY_HEIGHT_PX*5.0/6.0 %>" />
            <line class="splitter" x1="-9" x2="-9" y1="<%= DAY_HEIGHT_PX / 6.0 %>" y2="<%= DAY_HEIGHT_PX*5.0/6.0 %>" />
          </g>
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
                    " data-day="<%= d %>" data-is-today="<%= day(d).isSame(today) %>"/>
            <!-- plus lines -->
            <line class="new-session" x1="0" x2="0" y1="-0.2" y2="0.2" data-is-today="<%= day(d).isSame(today) %>"/>
            <line class="new-session" y1="0" y2="0" x1="-0.2" x2="0.2" data-is-today="<%= day(d).isSame(today) %>"/>
          </g>
        </g>

        <!-- day sum -->
        <text x="49" y="<%= DAY_HEIGHT_PX/2 %>" dy=".35em" class="day-sum"><%= formatDuration(daySum(d), '0') %></text>
      </g>
    </g>
    <!-- day label -->
    <% if (day(d).isSame(today)) { %>
      <!-- image indicating today -->
      <image xlink:href="img/star.png" x="-10" y ="<%= DAY_HEIGHT_PX/2 - 11 %>" height = "15px" width = "15px" />
      <!-- label indicating today -->
      <!-- <text x="88" y="<%= DAY_HEIGHT_PX/2 %>" dy="5px" text-anchor="end" class="day today">Today</text> -->
      <text x="88" y="<%= DAY_HEIGHT_PX/2 %>" dy="5px" text-anchor="end" class="day today"><%= day(d).format("ddd M/D")%></text>
    <% } else { %>
      <text x="88" y="<%= DAY_HEIGHT_PX/2 %>" dy=".33em" text-anchor="end" class="day"><%= day(d).format("ddd M/D")%></text>
    <% } %>
  </g>
<% }) %>
<line x1="100" x2="100" y1="-100" y2="<%= 10*DAY_HEIGHT_PX %>" class="separator" />
</g>
</script>
