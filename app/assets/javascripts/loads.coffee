$(document).ready () ->
  
  
  tooltip_content = (load) ->
    '<table>
      <tr>
        <td>Title:</td>
        <td>' + load.title + '</td>
      </tr>
      <tr>
        <td>User agent:</td>
        <td>' + load.user_agent + '</td>
      </tr>
      <tr>
        <td>User ID:</td>
        <td>' + load.cl_user_id + '</td>
      </tr>
      <tr>
        <td>Time on page:</td>
        <td>' + load.time_on_page + '</td>
      </tr>
    </table>'
  
  load_html = (load) -> 
    '<a rel="tooltipo" title="' + tooltip_content(load) + '" class="load-tooltip">
       <span class="uid"> </span>
       <span class="time">' + load.time + '</span>
       <span class="top">' + load.path + '</span>
     </a>'
  
  loads_div = d3.selectAll(".loads-col")
  .data(loads.reverse())
  .selectAll(".load")
  .data((d,i) -> d)
  .enter().append("div").attr("class", "load").html(load_html)
  
  $(".load-tooltip").tooltip({trigger: "click", html: true})