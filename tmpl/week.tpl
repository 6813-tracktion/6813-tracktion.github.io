<script type="text/template" id="weekTpl">
  <svg class="week">
    <line x1="0" y1="0" x2="999999" y2 = "0"stroke="green" stroke-width="4"/>
    <g class="week-label" transform="translate(750, 100) rotate(90)">
      <text style="text-anchor: middle;">Week <%= weekNumber() %></text>
    </g>
    <%= include #weekCumulative %>
    <g class="goal" />
    <%= include #weekDays %>
  </svg>
</script>
