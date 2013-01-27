$(document).ready () ->
  
  load_html = (load) -> 
    '<span class="uid"> </span>
     <span class="time">' + load.time + '</span>
     <span class="top">' + load.path + '</span>'
  
  loads_div = d3.selectAll(".loads-col")
  .data(loads.reverse())
  .selectAll(".load")
  .data((d,i) -> d)
  .enter().append("div").attr("class", "load").html(load_html)
  