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
            var day = $(event.target).data('day');
        var date = this.templateHelpers().day(day);
        -->
        <g style = "text-anchor: middle;" transform = "translate(50,20)">
            <text> WEEKLY GOAL </text>
            <text transform = "translate(0,20)"> By <%=day(6)%> </text>
        </g>

        <!--
            Insert the 30 min ticks
            
            NOTE: <pattern></pattern> does not work when I used it 
                    even in multiple variations.  But these ticks and
                    the minutes will be static in the sense that they will
                    not change over time so I will hard code these for now
                    until I find a better way of for looping this thing
        -->
        <g transform = "translate(150,32)">
            <line x1 = "0" y1 = "0" x2 = "0" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "50" y1 = "0" x2 = "50" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "100" y1 = "0" x2 = "100" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "150" y1 = "0" x2 = "150" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "200" y1 = "0" x2 = "200" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "250" y1 = "0" x2 = "250" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "300" y1 = "0" x2 = "300" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "350" y1 = "0" x2 = "350" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "400" y1 = "0" x2 = "400" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "450" y1 = "0" x2 = "450" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "500" y1 = "0" x2 = "500" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "550" y1 = "0" x2 = "550" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "600" y1 = "0" x2 = "600" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "650" y1 = "0" x2 = "650" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "700" y1 = "0" x2 = "700" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "750" y1 = "0" x2 = "750" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "800" y1 = "0" x2 = "800" y2 = "10" stroke = "black" stroke-width = "2"/>
            <line x1 = "850" y1 = "0" x2 = "850" y2 = "10" stroke = "black" stroke-width = "2"/>
        </g>

        <!--
            Add the minutes above the ticks
            
            NOTE: Same story as above with the for loop
        -->
        <g>
            <g transform = "translate(142,30)"><text> 30 </text></g>
            <g transform = "translate(192,30)"><text> 60 </text></g>
            <g transform = "translate(242,30)"><text> 90 </text></g>
            <g transform = "translate(288,30)"><text> 120 </text></g>
            <g transform = "translate(338,30)"><text> 150 </text></g>
            <g transform = "translate(388,30)"><text> 180 </text></g>
            <g transform = "translate(438,30)"><text> 210 </text></g>
            <g transform = "translate(488,30)"><text> 240 </text></g>
            <g transform = "translate(538,30)"><text> 270 </text></g>
            <g transform = "translate(588,30)"><text> 300 </text></g>
            <g transform = "translate(638,30)"><text> 330 </text></g>
            <g transform = "translate(688,30)"><text> 360 </text></g>
            <g transform = "translate(738,30)"><text> 410 </text></g>
        </g>

        <g class = "goal" transform = "translate(600,0)">
            <line x1 = "0" x2 = "0" y1 = "20" y2 = "<%=DAY_HEIGHT_PX/2+20%>" stroke = "black" stroke-width = "2"/>
            <image xlink:href="img/checkered-flag.png" x = "-1" y = "-5" 
                    height = "40px" width = "30px" />
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
