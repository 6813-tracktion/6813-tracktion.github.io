<script type="text/template" id="weekTpl">
    <svg class="week" height="<%= 98 + numDaysToShow() * DAY_HEIGHT_PX %>"
    style="<%= self.svgStyleAttr %>">

        <!--
            Text label for the "WEEK TOTAL" bar (currently not used)
        -->
        <!--
        <g transform = "translate(47,<%=DAY_HEIGHT_PX+33%>)">
            <text style="text-anchor: middle" class="weekTotalLabel"> Week Total </text>
        </g>
        -->

        <!--
            The horizontal axis.
        -->
        <g transform = "translate(110,74)">
            <line x1="0" y1="0" x2="1000" y2 = "0" stroke="black" stroke-width="2"/>
        </g>

        <!--
            Text label for goal line
            var day = $(event.target).data('day');
        var date = this.templateHelpers().day(day);
        -->
        <% if (canChangeEnd()) { %>
          <g style = "text-anchor: middle;" transform = "translate(60,42)">
            <text class="goalText">Weekly Goal</text>
            <text transform = "translate(0,20)">By <tspan class="editableEndDate"><%=end.format("ddd M/D")%></tspan></text>
          </g>
        <% } else { %>
          <!-- Don't bother showing end date: it's redundant with the days. -->
          <g style = "text-anchor: middle;" transform = "translate(60,57)">
            <text class="goalText">Weekly Goal</text>
          </g>
        <% } %>
        
        <g transform = "translate(110,74)">
            <!--
                Insert the 30 min ticks

                NOTE: <pattern></pattern> does not work when I used it
                        even in multiple variations.  But these ticks and
                        the minutes will be static in the sense that they will
                        not change over time so I will hard code these for now
                        until I find a better way of for looping this thing
            -->
            <% for (var m = 30; m <= 840; m += 30) { %>
                <line x1 = "<%= m*PX_PER_MIN %>" x2 = "<%= m*PX_PER_MIN %>" y1 = "-5" y2 = "5" stroke = "black" stroke-width = "2"/>
                <% for (var y1 = 20; y1 <= 360; y1 += 20) { %>
                    <line x1 = "<%= m*PX_PER_MIN %>" x2 = "<%= m*PX_PER_MIN %>" y1 = "<%= y1 %>" y2 = "<%= y1 + 5%>" stroke = "grey" stroke-width = "1" />
                <% } %>
            <% } %>
        </g>
        <!--
            Draws the Week Total bar showing the total number of minutes
                worked out this particular week.
            Bar color is
                YELLOW  -> if the goal has not been met
                GREEN   -> if goal has been met
        -->
        <g class = "weekTotal" transform = "translate(110,36)">
            <rect class="weekTotal" height="28" width="<%=rm2p(weekTotal())%>"
                style = "<%=totalBarColor(weekTotal())%>;"
            />
            <% if (rm2p(weekTotal()) >= 42) { %>
                <g transform="translate(<%=rm2p(weekTotal()) - 6%>, <%=28 / 2 + 6 %>)">
                    <text text-anchor="end" class="totalMinutes"><%= formatDuration(weekTotal())%></text>
                </g>
            <% } %> 
            <% if (weekTotal() < weekAttr('goal')) { %>
                <polyline points="<%=rm2p(weekTotal())%>,0 <%=rm2p(weekAttr('goal'))%>,0 <%=rm2p(weekAttr('goal'))%>,28 <%=rm2p(weekTotal())%>,28"
                    stroke-width="2" stroke="#ccc" stroke-dashoffset="<%=rm2p(weekTotal())%>" stroke-dasharray="5" fill="none"/>
            <% } %>
        </g>

        <!--
            Add the minutes above the ticks

            NOTE: Same story as above with the for loop
        -->
                
        <% for (var h = 1; h <= 14; h++ ) { %>
            <text transform = "translate(<%=h*60*PX_PER_MIN+102%>,91)"> <%=h%>h </text>
        <% } %>
        
        <!--        
        <g tansform = "translate(100,0)">
            <text transform = "translate(100,30)"> Hi </text>
            <g ><text transform = "translate(142,30)" >  </text></g>
            <g ><text transform = "translate(192,30)" >  1h </text></g>
            <g transform = "translate(242,30)"><text>  </text></g>
            <g transform = "translate(292,30)"><text>  2h </text></g>
            <g transform = "translate(338,30)"><text>  </text></g>
            <g transform = "translate(392,30)"><text>  3h </text></g>
            <g transform = "translate(438,30)"><text>  </text></g>
            <g transform = "translate(492,30)"><text>  4h </text></g>
            <g transform = "translate(538,30)"><text>  </text></g>
            <g transform = "translate(592,30)"><text>  5h </text></g>
            <g transform = "translate(638,30)"><text>  </text></g>
            <g transform = "translate(692,30)"><text>  6h </text></g>
            <g transform = "translate(738,30)"><text>  </text></g>
        </g>
        -->
                
                
        <g class = "goal" transform = "translate(<%= weekAttr('goal') * PX_PER_MIN + 110 %>,0)">
            <line x1 = "0" x2 = "0" y1 = "20" y2 = "74" stroke = "black" stroke-width = "2"/>
            <image xlink:href="img/checkered-flag.png" x = "-1" y = "-4"
                    height = "40px" width = "30px" />
        </g>

        <g transform="translate(10,96)">
            <!--
            <g class="week-label" transform="translate(750, 100) rotate(90)">
            <text style="text-anchor: middle;">Week <%= weekNumber() %></text>
            </g>
            -->
            <%= include #weekCumulative %>
            <%= include #weekDays %>
        </g>
    </svg>
</script>
