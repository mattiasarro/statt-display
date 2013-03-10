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
  
  
  loads_page_listener = (e) ->
    url = $(this).attr("data-ajax-uri")
    clicked_page = $(this)
    jQuery.ajax(url, {
      dataType: "json", # preferred response data type
      success: (loads_page,status,xhr) -> (
        update_loads_columns(loads_page.loads)
        new_load_pg = clicked_page.parent().attr("data-page-nr")
        ui.loads_pagination.current_pg = parseInt(new_load_pg)
        draw_pagination(ui)
      )
    })
    false # cancel ordinary click
  $(".loads-page").live("click", loads_page_listener)
  
  
  ui_sample = ->
    {
      site_id: "50d6549e1b47f8a410000002",
      loads_pagination: {
        current_pg: 2,
        nr_pages: 16
      },
      visitors_pg: 1,
      graph: {
        nr_bars: 1,
        duration: 360
      },
      timeframe: {
        from: 123,
        to: 123
      },
    }
  
  
  loads_page_ajax_uri = (d) ->
    ret = jQuery.extend(true, {}, ui) # clone ui object
    ret.loads_pagination.current_pg = d.nr
    delete ret.site_id
    "/sites/#{ui.site_id}/loads?" + jQuery.param(ret)
  
  page_windows = (ui) ->
    nr_pages = ui.loads_pagination.nr_pages
    current_pg = ui.loads_pagination.current_pg
    first_pg_of_tail = nr_pages - 2
    
    windows = []
    console.log(current_pg + "/" + nr_pages)
    get_window = (range) ->
      get_obj = (pg_nr) -> ({nr: pg_nr, name: pg_nr})
      get_obj pg for pg in range
    
    if nr_pages <= 13
      [get_window([1..nr_pages])]
    else if current_pg in [1..6]
      [
        get_window([1..8])
        get_window([(nr_pages-2)..nr_pages])
      ]
    else if current_pg in [7..(nr_pages-5)]
      [
        get_window([1..3])
        get_window([(current_pg-2)..(current_pg+2)])
        get_window([(nr_pages-2)..nr_pages])
      ]
    else if current_pg in [(nr_pages-6)..nr_pages]
      [
        get_window([1..3])
        get_window([(nr_pages-7)..nr_pages])
      ]
    else
      console.log("ERROR")
  
  
  draw_pagination = (ui) ->
    li_class = (d) ->
      ret = ' '
      ret += ' active' if d.nr == ui.loads_pagination.current_pg
      ret += ' disabled' if false
      ret
    
    
    uls = d3.select(".pagination").selectAll("ul")
    .data(page_windows(ui)) # from _js_data.erb
    
    uls.enter().insert("ul") 
    uls.exit().remove()
    
    lis = uls.selectAll("li").data((d,i) -> d)
    
    lis.enter()
    .insert("li")
      .attr("class", li_class)
      .attr("data-page-nr", (d) -> d.nr)
      .insert("a")
        .attr("class", "loads-page")
        .attr("data-ajax-uri", loads_page_ajax_uri)
        .text((d) -> d.name)
    
    lis # update
      .data((d,i) -> d)
      .attr("class", li_class)
      .attr("data-page-nr", (d) -> d.nr)
      .select("a")
        .attr("class", "loads-page")
        .attr("data-ajax-uri", loads_page_ajax_uri)
        .text((d) -> d.name)
    
    lis.exit().remove()
  
  draw_pagination(ui)
  