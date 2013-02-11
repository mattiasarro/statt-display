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
  
  
  update_loads_columns = (loads_columns) ->
    loads_div = d3.selectAll(".loads-col")
    .data(loads_columns.reverse())
    .selectAll(".load")
    .data((d,i) -> d)
    
    # enter
    loads_div.enter()
    .append("div").attr("class", "load").html(load_html)
    
    # update
    loads_div.html(load_html)
    
    # exit
    loads_div.exit().remove()
    
  update_loads_columns(loads_page.loads)
  
  $(".load-tooltip").tooltip({trigger: "click", html: true})
  
  update_active_page = (page_clicked) ->
    page_links_list = (selector) -> (page_clicked.parent().parent().find(selector))
    
    previously_active = page_links_list("li.active")
    new_nr = page_clicked.parent().attr("data-page-nr")
    new_active = page_links_list("li:not(.prev_pg):not(.next_pg)[data-page-nr=" + new_nr + "]")
    
    update_link_attributes(page_links_list(".prev_pg"), new_active.prev())
    update_link_attributes(page_links_list(".next_pg"), new_active.next())
    
    previously_active.removeClass("active")
    new_active.addClass("active")
  
  update_link_attributes = (to_update, update_with) ->    
    to_update.attr("data-page-nr", update_with.attr("data-page-nr"))
    a_to   = to_update.find("a")
    a_from = update_with.find("a")
    a_to.attr("data-ajax-uri", a_from.attr("data-ajax-uri"))
    a_to.attr("href", a_from.attr("href"))
    
    
  $(".loads-page").click (e) ->
    url = $(this).attr("data-ajax-uri")
    clicked_page = $(this)
    jQuery.ajax(url, {
      dataType: "json", # preferred response data type
      success: (loads_page,status,xhr) -> (
        update_loads_columns(loads_page.loads)
        update_active_page(clicked_page)
      )
    })
    false # cancel ordinary click