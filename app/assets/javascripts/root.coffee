$(document).ready () ->
  
  data = [4,8,15,16,23,42]
  bar_height = 20
  chart_height = bar_height * data.length
  chart_width = 420
  chart_padding = 20
  
  chart = d3.select("#wrapper}").append("svg")
  .attr("class", "chart")
  .attr("width", chart_width + chart_padding)
  .attr("height", chart_height + chart_padding)
  
  .append("g")
  .attr("transform", "translate(10,15)")
  
  x = d3.scale.linear()
  .domain([0, d3.max(data)])
  .range([0, chart_width])
  
  y = d3.scale.ordinal()
  .domain(data)
  .rangeBands([0,chart_height])
  
  # add padding
  
  
  # y axis line
  chart.append("line")
  .attr("y1", 0)
  .attr("y2", 120)
  .style("stroke", "#000}")
  
  # add ticks
  ticks = chart.selectAll("line")
  .data(x.ticks(10))
  .enter().append("line")
  .attr("x1", x)
  .attr("x2", x)
  .attr("y1", 0)
  .attr("y2", 120)
  .style("stroke", "#ccc}")
  
  # add labels to ticks
  labels = chart.selectAll(".rule")
  .data(x.ticks(10))
  .enter().append("text")
  .attr("class", "rule")
  .attr("x", x)
  .attr("y", 0)
  .attr("dy", -3)
  .attr("text-anchor", "middle")
  .text(String)
  
  bars = chart.selectAll("rect")
  .data(data)
  .enter().append("rect") # break into a section bars.enter()
  .attr("y", y)
  .attr("width", x)
  .attr("height", y.rangeBand())
  
  text = chart.selectAll(".values")
  .data(data)
  .enter().append("text")
  .attr("class", "values")
  .attr("x", x)
  .attr("y", (d) -> ( y(d) + y.rangeBand() / 2 ))
  .attr("dx", -3) # padding-right
  .attr("dy", ".35em") # vertical-align: middle
  .attr("text-anchor", "end") # text-align: right
  .text(String)