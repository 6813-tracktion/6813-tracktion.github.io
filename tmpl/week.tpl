<script type="text/template" id="weekTpl">
    <svg class="week" height="<%= 98 + numDaysToShow() * DAY_HEIGHT_PX + 25 %>">
    <g class="fractionalCoordinatesFixer" transform="<%= self.fractionalCoordinatesFix %>">
    <g transform="translate(8, 25)"> <!-- translate for title and wider today label -->

        <!-- Vertical dotted lines per hour: below the days. -->
        <g transform = "translate(110,74)">
            <% for (var m = 30; m <= maxMinutes(); m += 30) { %>
                <% for (var y1 = 20; y1 <= 360; y1 += 20) { %>
                    <line x1 = "<%= rm2p(m) %>" x2 = "<%= rm2p(m) %>" y1 = "<%= y1 %>" y2 = "<%= y1 + 5%>" stroke = "grey" stroke-width = "1" />
                <% } %>
            <% } %>
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

        <!--
            Title for week
        -->
        <g transform="translate(420, -4)" class="weekTitle">
            <!-- Start / End dates -->
            <% if (canChangeEnd()) { %>
                <!-- Text -->
                <text style="text-anchor: middle" class="weekTitle"><%=beginning.format("ddd M/D")%> &ndash;
                    <tspan class="editableEndDate">
                        <%=end.format("ddd M/D")%>
                    </tspan>
                </text>
                <!-- Edit icon -->
                <image xlink:href="img/flaticon/pencil.png" class="editIcon" x="98" y="-16" height="16px" width="16px" />
            <% } else { %>
                <text style="text-anchor: middle" class="weekTitle"><%=beginning.format("ddd M/D")%> &ndash; <%=end.format("ddd M/D")%></text>
            <% } %>
        </g>

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
        <g style = "text-anchor: middle;" transform = "translate(66,42)">
            <text class="goalText">Progress</text>
            <text class="goalText" transform="translate(0,20)">to Goal</text>
        </g>

        <g transform = "translate(110,74)">
            <!--
                Insert the 30 min ticks

                NOTE: <pattern></pattern> does not work when I used it
                        even in multiple variations.  But these ticks and
                        the minutes will be static in the sense that they will
                        not change over time so I will hard code these for now
                        until I find a better way of for looping this thing
            -->
            <% for (var m = 30; m <= maxMinutes(); m += 30) { %>
                <line x1 = "<%= rm2p(m) %>" x2 = "<%= rm2p(m) %>" y1 = "-5" y2 = "5" stroke = "black" stroke-width = "2"/>
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
                <!-- Dashed lines -->
                <% _.each([0, 28], function(y) { %>
                    <line x1="<%= rm2p(weekTotal()) %>" x2="<%= rm2p(weekAttr('goal')) %>" y1="<%= y %>" y2="<%= y %>"
                        stroke-width="2" stroke="#ccc" stroke-dashoffset="<%= rm2p(weekTotal()) %>" stroke-dasharray="5"/>
                <% }); %>
                <!-- Invisible rect to trigger mouseover -->
                <rect class="gapRemaining" height="28" x="<%=rm2p(weekTotal())%>"
                    width="<%=rm2p(weekAttr('goal')) - rm2p(weekTotal())%>"
                />
            <% } %>
        </g>

        <!--
            Add the minutes above the ticks

            NOTE: Same story as above with the for loop
        -->

        <% for (var h = 1, H = maxHours(); h <= H; h++ ) { %>
            <text transform = "translate(<%=h * rm2p(60) + 102 %>,91)"> <%=h%>h </text>
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

        <g class = "goal" transform = "translate(<%= rm2p(weekAttr('goal')) + 110 %>,0)">
            <line x1 = "0" x2 = "0" y1 = "20" y2 = "74" stroke = "black" stroke-width = "2"/>
            <image xlink:href="img/checkered-flag.png" x = "-1" y = "-4"
                    height = "40px" width = "30px" />
        </g>

    </g> <!-- translate for title -->
    </g> <!-- fractionalCoordinatesFixer -->
    </svg>
</script>
