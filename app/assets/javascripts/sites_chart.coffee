$(document).ready () ->
  
  chart_width = 720
  chart_height = 80
  bar_width = chart_width / nr_bars # 12
  
  x = d3.scale.linear() # index * bar_width
  .domain([0, bar_duration])
  .range([0, bar_width])
  
  y = d3.scale.linear()
  .domain([0, max_value]) # data.value
  .rangeRound([0, chart_height]) # rangeRound() means values are rounded to Int
  
  chart = d3.select("#chart_container}").append("svg")
  .attr("class", "chart")
  .attr("width", chart_width)
  .attr("height", chart_height)
  
  draw = ->
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
    
    bars = chart.selectAll("rect")
    .data(data, key_function)
    
    bars.enter().insert("rect", "line")
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
  
  # x-axis line
  chart.append("line")
  .attr("x1", 0)
  .attr("x2", bar_width * nr_bars)
  .attr("y1", chart_height - .5)
  .attr("y2", chart_height - .5)
  .style("stroke", "steelblue")
  