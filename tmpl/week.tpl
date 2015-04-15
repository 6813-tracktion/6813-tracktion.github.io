<script type="text/template" id="weekTpl">
    <svg class="week">
        
        <!--
            Draws the Week Total bar showing the total number of minutes 
                worked out this particular week.
            Bar color is 
                YELLOW  -> if the goal has not been met
                GREEN   -> if goal has been met
        -->
        <g class = "weekTotal" transform = "translate(100,<%=DAY_HEIGHT_PX+5%>)">
            <rect class="weekTotal" height="<%= DAY_HEIGHT_PX %>" width="<%=rm2p(cumulative(6))%>"
                style = "<%=totalBarColor(rm2p(cumulative(6)))%>;"
            />
        </g>

        <!--
            Text label for the "WEEK TOTAL" bar
        -->
        <g transform = "translate(45,<%=DAY_HEIGHT_PX+35%>)">
            <text style="text-anchor: middle"> WEEK TOTAL </text>
        </g>

        <!--
            The editable goal line. 
            The default goal is going to be set to 300 min / week.
        -->
        <g transform = "translate(0,40)">
            <line x1="100" y1="0" x2="600" y2 = "0"stroke="<%= goalLineColor(rm2p(cumulative(6))) %>" stroke-width="4"/>
        </g>

        <!--
            Text label for goal line
        -->
        <g style = "text-anchor: middle;" transform = "translate(50,20)">
            <text> WEEKLY GOAL </text>
            <text transform = "translate(0,20)"> By <%=day(6)%> </text>
        </g>

        <!--
            Insert the 30 min ticks
        -->
        <g transform = "translate(90,90)">
            <pattern x = "0" y = "0" height = "10" width = "500">
                <line x1 = "0" y1 = "0" x2 = "0" y2 = "10" stroke = "black" stroke-width = "20"/>
            </pattern>
        </g>

        <g transform="translate(0,<%=DAY_HEIGHT_PX*2.25%>)"> 
            <g class="week-label" transform="translate(750, 100) rotate(90)">
            <text style="text-anchor: middle;">Week <%= weekNumber() %></text>
            </g>
            <%= include #weekCumulative %>
            <g class="goal" />
            <%= include #weekDays %>
        </g>
    </svg>
</script>
