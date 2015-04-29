<script type="text/template" id="weekTpl">
    <!-- XXX: Express 106 in terms of DAY_HEIGHT_PX -->
    <svg class="week" height="<%= 106 + numDaysToShow() * DAY_HEIGHT_PX %>"
    style="<%= self.svgStyleAttr %>"><g transform="translate(10,10)">

        <!--
            Text label for the "WEEK TOTAL" bar
        -->
        <g transform = "translate(47,<%=DAY_HEIGHT_PX+33%>)">
            <text style="text-anchor: middle" class="weekTotalLabel"> Week Total </text>
        </g>

        <!--
            The editable goal line.
            The default goal is going to be set to 300 min / week.
        -->
        <g transform = "translate(100,42)">
            <line x1="0" y1="0" x2="1000" y2 = "0"stroke="black" stroke-width="2"/>
        </g>

        <!--
            Text label for goal line
            var day = $(event.target).data('day');
        var date = this.templateHelpers().day(day);
        -->
        <% if (canChangeEnd()) { %>
          <g style = "text-anchor: middle;" transform = "translate(50,12)">
            <text class="goalText">Weekly Goal</text>
            <text transform = "translate(0,20)">By <tspan class="editableEndDate"><%=end.format("ddd M/D")%></tspan></text>
          </g>
        <% } else { %>
          <!-- Don't bother showing end date: it's redundant with the days. -->
          <g style = "text-anchor: middle;" transform = "translate(50,27)">
            <text class="goalText">Weekly Goal</text>
          </g>
        <% } %>
        
        <g transform = "translate(100,32)">
            <!--
                Insert the 30 min ticks

                NOTE: <pattern></pattern> does not work when I used it
                        even in multiple variations.  But these ticks and
                        the minutes will be static in the sense that they will
                        not change over time so I will hard code these for now
                        until I find a better way of for looping this thing
            -->
            <% for (var m = 30; m <= 540; m += 30) { %>
                <line x1 = "<%= m*PX_PER_MIN %>" x2 = "<%= m*PX_PER_MIN %>" y1 = "0" y2 = "10" stroke = "black" stroke-width = "2"/>
                <% for (var y1 = 15; y1 <= 355; y1 += 20) { %>
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
        <g class = "weekTotal" transform = "translate(100,<%=DAY_HEIGHT_PX + 7 %>)">
            <rect class="weekTotal" height="<%= DAY_HEIGHT_PX %>" width="<%=rm2p(weekTotal())%>"
                style = "<%=totalBarColor(weekTotal())%>;"
            />
            <% if (rm2p(weekTotal()) >= 42) { %>
                <g transform="translate(<%=rm2p(weekTotal()) - 6%>, <%=DAY_HEIGHT_PX / 2 + 6 %>)">
                    <text text-anchor="end" class="totalMinutes"><%= formatDuration(weekTotal())%></text>
                </g>
            <% } %>
        </g>

        <!--
            Add the minutes above the ticks

            NOTE: Same story as above with the for loop
        -->
        <g tansform = "translate(100,0)">
            <g transform = "translate(142,30)"><text>  </text></g>
            <g transform = "translate(192,30)"><text>  1h </text></g>
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

        <g class = "goal" transform = "translate(<%= weekAttr('goal') * 5 / 3 + 100 %>,0)">
            <line x1 = "0" x2 = "0" y1 = "10" y2 = "<%=DAY_HEIGHT_PX/2+22%>" stroke = "black" stroke-width = "2"/>
            <image xlink:href="img/checkered-flag.png" x = "-1" y = "-14"
                    height = "40px" width = "30px" />
        </g>

        <g transform="translate(0,<%=Math.round(DAY_HEIGHT_PX*2+10)%>)">
            <g class="week-label" transform="translate(750, 100) rotate(90)">
            <text style="text-anchor: middle;">Week <%= weekNumber() %></text>
            </g>
            <%= include #weekCumulative %>
            <%= include #weekDays %>
        </g>
    </g></svg>
</script>
