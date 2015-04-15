<script type="text/template" id="weekTpl">
    <svg class="week" height = "1000px">

        <g class = "weekTotal" transform = "translate(100,0)">
            <rect class="weekTotal" height="<%= DAY_HEIGHT_PX %>" width="<%=rm2p(cumulative(6))%>"
                style = "fill:rgb(255,255,20);"
            />
        </g>

        <line x1="100" y1="0" x2="600" y2 = "0"stroke="green" stroke-width="4"/>

        <g transform="translate(0,<%=DAY_HEIGHT_PX*1.25%>)"> 
            <g class="week-label" transform="translate(750, 100) rotate(90)">
            <text style="text-anchor: middle;">Week <%= weekNumber() %></text>
            </g>
            <%= include #weekCumulative %>
            <g class="goal" />
            <%= include #weekDays %>
        </g>
    </svg>
</script>
