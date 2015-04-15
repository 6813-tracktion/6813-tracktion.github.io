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
                style = "<%=totalBarColor(cumulative(6))%>;"
            />
        </g>

        <!--
            Text label for the "WEEK TOTAL" bar
        -->
        <g transform = "translate(45,<%=DAY_HEIGHT_PX+35%>)">
            <text style="text-anchor: middle"> Week Total </text>
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
        <g style = "text-anchor: middle;" transform = "translate(50,20)">
            <text> Weekly Goal </text>
            <text transform = "translate(0,20)"> By <%=day(6).format("MMM DD")%> </text>
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
            
            <line x1 = "50" y1 = "0" x2 = "50" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "50" x2 = "50" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "50" x2 = "50" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            <line x1 = "100" y1 = "0" x2 = "100" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "100" x2 = "100" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "100" x2 = "100" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            <line x1 = "150" y1 = "0" x2 = "150" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "150" x2 = "150" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "150" x2 = "150" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            <line x1 = "200" y1 = "0" x2 = "200" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "200" x2 = "200" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "200" x2 = "200" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            <line x1 = "250" y1 = "0" x2 = "250" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "250" x2 = "250" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "250" x2 = "250" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            <line x1 = "300" y1 = "0" x2 = "300" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "300" x2 = "300" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "300" x2 = "300" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            <line x1 = "350" y1 = "0" x2 = "350" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "350" x2 = "350" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "350" x2 = "350" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            
            <line x1 = "400" y1 = "0" x2 = "400" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "400" x2 = "400" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "400" x2 = "400" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            
            <line x1 = "450" y1 = "0" x2 = "450" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "450" x2 = "450" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "450" x2 = "450" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            
            <line x1 = "500" y1 = "0" x2 = "500" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "500" x2 = "500" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "500" x2 = "500" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            
            <line x1 = "550" y1 = "0" x2 = "550" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "550" x2 = "550" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "550" x2 = "550" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            
            <line x1 = "600" y1 = "0" x2 = "600" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "600" x2 = "600" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "600" x2 = "600" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            
            <line x1 = "650" y1 = "0" x2 = "650" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "650" x2 = "650" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "650" x2 = "650" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            
            <line x1 = "700" y1 = "0" x2 = "700" y2 = "10" stroke = "black" stroke-width = "2"/>
            
                <line x1 = "700" x2 = "700" y1 = "15" y2 = "20" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "35" y2 = "40" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "55" y2 = "60" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "75" y2 = "80" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "95" y2 = "100" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "115" y2 = "120" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "135" y2 = "140" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "155" y2 = "160" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "175" y2 = "180" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "195" y2 = "200" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "215" y2 = "220" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "235" y2 = "240" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "255" y2 = "260" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "275" y2 = "280" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "295" y2 = "300" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "315" y2 = "320" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "335" y2 = "340" stroke = "grey" stroke-width = "1" />
                <line x1 = "700" x2 = "700" y1 = "355" y2 = "360" stroke = "grey" stroke-width = "1" />
            
            
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
            <g transform = "translate(738,30)"><text> 390 </text></g>
        </g>

        <g class = "goal" transform = "translate(<%= weekAttr('goal') * 5 / 3 + 100 %>,0)">
            <line x1 = "0" x2 = "0" y1 = "20" y2 = "<%=DAY_HEIGHT_PX/2+22%>" stroke = "black" stroke-width = "2"/>
            <image xlink:href="img/checkered-flag.png" x = "-1" y = "-5" 
                    height = "40px" width = "30px" />
        </g>

        <g transform="translate(0,<%=Math.round(DAY_HEIGHT_PX*2.25)%>)">
            <g class="week-label" transform="translate(750, 100) rotate(90)">
            <text style="text-anchor: middle;">Week <%= weekNumber() %></text>
            </g>
            <%= include #weekCumulative %>
            <%= include #weekDays %>
        </g>
    </svg>
</script>
