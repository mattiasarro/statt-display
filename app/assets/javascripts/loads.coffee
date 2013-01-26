$(document).ready () ->
  
  load_html = (load) -> 
    '<span class="uid"> </span>
     <span class="time">' + load.time + '</span>
     <span class="top">' + load.path + '</span>'
  
  loads_col = d3.select(".loads-col")
  
  loads_col.selectAll("div")
  .data(loads) # loads is defined by graph/_data.erb
  .enter().append("div").attr("class", "load").html(load_html)