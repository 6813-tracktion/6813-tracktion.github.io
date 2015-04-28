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
        
        <g transform = "translate(100,0)">
            <!--
                Insert the 30 min ticks

                NOTE: <pattern></pattern> does not work when I used it
                        even in multiple variations.  But these ticks and
                        the minutes will be static in the sense that they will
                        not change over time so I will hard code these for now
                        until I find a better way of for looping this thing
            -->
            <g transform = "translate(<%=30*PX_PER_MIN%>,32)">
                <line x1 = "0" y1 = "0" x2 = "0" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "0" x2 = "0" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "0" x2 = "0" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />

                <line x1 = "<%=30*PX_PER_MIN%>" y1 = "0" x2 = "<%=30*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=30*PX_PER_MIN%>" x2 = "<%=30*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />

                <line x1 = "<%=60*PX_PER_MIN%>" y1 = "0" x2 = "<%=60*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=60*PX_PER_MIN%>" x2 = "<%=60*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />

                <line x1 = "<%=90*PX_PER_MIN%>" y1 = "0" x2 = "<%=90*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=90*PX_PER_MIN%>" x2 = "<%=90*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />

                <line x2 = "<%=120*PX_PER_MIN%>" y1 = "0" x1 = "<%=120*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=120*PX_PER_MIN%>" x1 = "<%=120*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />

                <line x2 = "<%=150*PX_PER_MIN%>" y1 = "0" x1 = "<%=150*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x2 = "<%=150*PX_PER_MIN%>" x1 = "<%=150*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />

                <line x1 = "<%=180*PX_PER_MIN%>" y1 = "0" x2 = "<%=180*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=180*PX_PER_MIN%>" x2 = "<%=180*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />

                <line x1 = "<%=210*PX_PER_MIN%>" y1 = "0" x2 = "<%=210*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=210*PX_PER_MIN%>" x2 = "<%=210*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />


                <line x1 = "<%=240*PX_PER_MIN%>" y1 = "0" x2 = "<%=240*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=240*PX_PER_MIN%>" x2 = "<%=240*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />


                <line x1 = "<%=270*PX_PER_MIN%>" y1 = "0" x2 = "<%=270*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=270*PX_PER_MIN%>" x2 = "<%=270*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />


                <line x1 = "<%=300*PX_PER_MIN%>" y1 = "0" x2 = "<%=300*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=300*PX_PER_MIN%>" x2 = "<%=300*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />


                <line x1 = "<%=330*PX_PER_MIN%>" y1 = "0" x2 = "<%=330*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=330*PX_PER_MIN%>" x2 = "<%=330*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />


                <line x1 = "<%=360*PX_PER_MIN%>" y1 = "0" x2 = "<%=360*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=360*PX_PER_MIN%>" x2 = "<%=360*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />


                <line x1 = "<%=390*PX_PER_MIN%>" y1 = "0" x2 = "<%=390*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=390*PX_PER_MIN%>" x2 = "<%=390*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />


                <line x1 = "<%=420*PX_PER_MIN%>" y1 = "0" x2 = "<%=420*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>

                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                    <line x1 = "<%=420*PX_PER_MIN%>" x2 = "<%=420*PX_PER_MIN%>" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />


                <line x1 = "<%=450*PX_PER_MIN%>" y1 = "0" x2 = "<%=450*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>
                <line x1 = "<%=480*PX_PER_MIN%>" y1 = "0" x2 = "<%=480*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>
                <line x1 = "<%=510*PX_PER_MIN%>" y1 = "0" x2 = "<%=510*PX_PER_MIN%>" y2 = "10" stroke = "black" stroke-width = "2"/>
            </g>
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
