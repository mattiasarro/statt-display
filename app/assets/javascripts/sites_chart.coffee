$(document).ready () ->
  
  chart_width = 938  # including padding
  chart_height = 193 # including padding
  padding = 10
  bar_width = (chart_width - (2 * padding)) / nr_bars # 12
  
  x = d3.scale.linear() # index * bar_width
  .domain([0, bar_duration])
  .range([padding, bar_width + padding])
  
  y = d3.scale.linear()
  .domain([0, max_value]) # data.value
  .rangeRound([padding, chart_height]) # rangeRound() means values are rounded to Int
  
  chart = d3.select("#chart_container").append("svg")
  .attr("class", "chart")
  .attr("width", chart_width)
  .attr("height", chart_height)
  .append("g")
  .attr("transform", "translate(" + padding + "," + padding + ")")
  
  xAxis = d3.svg.axis().scale(y).orient("left")
  xAxis.ticks(5)
  
  
  chart.append("g")
  .attr("class", "axis")
  .call(xAxis)
  
  draw = ->
    highlight = chart.selectAll("rect.highlight")
    .data([{from: loads_page.earliest_load_time, to: loads_page.latest_load_time}])
    .enter().insert("rect")
    .attr("class", "highlight")
    .attr("x", (d) -> (x(d.from - from) - .5))
    .attr("y", -(padding + 1))
    .attr("width", (d) -> 
      duration = d.to - d.from
      total_width = 920
      width = duration * (total_width/timeframe_duration)
    )
    .attr("height", chart_height + padding)
    
    key_function = (d) -> (typeof d == undefined ? 0 : d.time) 
    bar_x = (d,i) -> (x(d.time - from) - .5)
    bar_y = (d) -> 
      if typeof d == undefined
        0
      else 
        chart_height - y(d.value) - 1
        
    bar_height = (d) -> 
      if typeof d == undefined
        0
      else
        y(d.value)
    
    bars = chart.selectAll("rect.bar")
    .data(data, key_function)
    
    bars.enter().insert("rect")
    .attr("class", "bar")
    # .attr("x", (d,i) -> (x(i+1) - .5)) # entering bars all shifted to the right
    .attr("x", bar_x)
    .attr("y", bar_y)
    .attr("width", bar_width)
    .attr("height", bar_height)
    .transition() # fade the entering bar in
    .duration(1000)
    .attr("x", bar_x) # shift it to current position
    
    # shift all bars to the left
    bars.transition()
    .duration(1000)
    .attr("x", bar_x)
    
    bars.exit().transition()
    .duration(1000)
    .attr("x", (d,i) -> (x(i-1) - .5)) # one bar outside of view (left)
    .remove()
    
  
  draw()
  # setInterval ->
  #   data.shift()
  #   data.push(next())
  #   draw()
  # , 3000 # interval has to be slightly bigger than internal transitions' speed
  
  # # x-axis line
  # chart.append("line")
  # .attr("x1", 0)
  # .attr("x2", bar_width * nr_bars)
  # .attr("y1", chart_height - .5)
  # .attr("y2", chart_height - .5)
  # .style("stroke", "steelblue")
  