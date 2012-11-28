$(document).ready () ->
  
  # time could be a range, e.g. a 3h bar
  # {"time": 1297110663, "value": 56},
  # {"time": 1297110664, "value": 53},
  # {"time": 1297110665, "value": 58},
  # {"time": 1297110666, "value": 58},
  chart_width = 720
  chart_height = 80
  bar_width = chart_width / nr_bars # 12
  
  x = d3.scale.linear() # index * bar_width
  .domain([0, 1])
  .range([0, bar_width])
  
  y = d3.scale.linear()
  .domain([0, 100]) # data.value
  .rangeRound([0, chart_height]) # rangeRound() means values are rounded to Int
  
  chart = d3.select("#chart}").append("svg")
  .attr("class", "chart")
  .attr("width", bar_width * data.length - 1)
  .attr("height", chart_height)
  
  draw = ->
    bar_x = (d,i) -> (x(i) - .5)
      
    bars = chart.selectAll("rect")
    .data(data, (d) -> d.time) # key function is d.time
    
    bars.enter().insert("rect", "line")
    # .attr("x", (d,i) -> (x(i+1) - .5)) # entering bars all shifted to the right
    .attr("x", bar_x)
    .attr("y", (d) -> (chart_height - y(d.value) - .5))
    .attr("width", bar_width)
    .attr("height", (d) -> y(d.value))
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
  .attr("x2", bar_width * data.length)
  .attr("y1", chart_height - .5)
  .attr("y2", chart_height - .5)
  .style("stroke", "#000}")
  