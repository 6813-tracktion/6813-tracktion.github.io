
<script type="text/template" id="weekCumulative">
      <g class="cumulative">
      <% _.each(reversedDays(), function(d, i) { %>
        <!-- It would be more logical to put the vertices on the lines between
             days, so that two consecutive vertices will straddle the day that
             reflects the difference between them, but I think this is
             outweighed by the downside of more of the cumulative line graph
             being hidden by the bars. -->
        <g transform="translate(100, <%= DAY_HEIGHT_PX * (i + 1/2) %>)">
          <% if(urlVar('cumulative') != 'line'){ %>
            <rect class="cumulative" y="<%= -DAY_HEIGHT_PX/2 - (i == 0 ? 5 : 0) %>" height="<%= DAY_HEIGHT_PX + (i == 0 ? 5 : 0) %>" width="<%= rm2p(cumulative(d)) %>" />
            <rect class="cumulative-curr" y="<%= -DAY_HEIGHT_PX/2 - (i == 0 ? 5 : 0) %>" height="<%= DAY_HEIGHT_PX + (i == 0 ? 5 : 0) %>" width="<%= rm2p(cumulative(d)) - rm2p(cumulative(d-1)) %>" x="<%= rm2p(cumulative(d-1)) %>" />
            <line class="cumulative end" y1="<%= -DAY_HEIGHT_PX/2 - (i == 0 ? 5 : 0) %>" y2="<%= DAY_HEIGHT_PX/2 %>" x1="<%= rm2p(cumulative(d)) %>" x2="<%= rm2p(cumulative(d)) %>" />
            <% if(cumulative(d) > cumulative(d - 1)) { %>
              <line class="cumulative end" y1="<%= DAY_HEIGHT_PX/2 %>" y2="<%= DAY_HEIGHT_PX/2 %>" x1="<%= rm2p(cumulative(d-1)) %>" x2="<%= rm2p(cumulative(d)) %>" />
            <% } %>
          <% } else { %>
            <% if(i > 0) { %>
              <line class="cumulative" x1="<%= rm2p(cumulative(d+1)) %>" x2="<%= rm2p(cumulative(d)) %>" y1="<%= -DAY_HEIGHT_PX %>" y2="0" />
            <% } else { %>
              <line class="cumulative" x1="<%= rm2p(cumulative(d)) %>" x2="<%= rm2p(cumulative(d)) %>" y1="<%= -DAY_HEIGHT_PX/2 - 5 %>" y2="0" />
            <% } %>
            <circle class="cumulative" cy="0" cx="<%= rm2p(cumulative(d)) %>" r="5" />
          <% } %>
          <!-- cumulative fill -->
          <!-- IMO, filling under the cumulative graph is misleading because
               the area under it doesn't have any meaning. -->
          <!--
          <text class="cumulative" y="<%= DAY_HEIGHT_PX/2 %>" x="<%= rm2p(cumulative(d)) + 20 %>" dy=".35em"><%= cumulative(d) %></text>
          -->
        </g>
      <% }) %>
      </g>
</script>
