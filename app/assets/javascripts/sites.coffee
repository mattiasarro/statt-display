//= require jquery.ui.core
//= require jquery.ui.datepicker
//= require jquery.ui.selectable
//= require daterange_selector

$(document).ready () ->
  setup_daterange_selector = -> 
    get_graph_date = (from_to) ->
      year = $("#graph_#{from_to}_1i").val()
      month = $("#graph_#{from_to}_2i").val()
      day = $("#graph_#{from_to}_3i").val()
      new Date("#{year}-#{month}-#{day}")
    
    drs = DaterangeSelector({
      selector: "#datepicker", 
      nr_months: 2,
      start_date: () -> (
        get_graph_date("from")
      ),
      end_date: () -> (
        get_graph_date("to")
      ),
      start_date_selected: (time) -> (
        update_rails_datetime_select("#graph_from", time, "start")
      ),
      end_date_selected: (time) -> (
        update_rails_datetime_select("#graph_to", time, "end")
        $("#graph_type").val("custom")
        $("#daterange-select-dropdowns form").submit()
      )
    })
    
    $("#dp_prev").click ->
      date = $("#datepicker").datepicker("getDate")
      date.setMonth(date.getMonth() - 1)
      $("#datepicker").datepicker("setDate", date)
      drs.initSelected()
    
    $("#dp_next").click ->
      date = $("#datepicker").datepicker("getDate")
      date.setMonth(date.getMonth() + 1)
      $("#datepicker").datepicker("setDate", date)
      drs.initSelected()
    
  
  $('#daterange-select').popover({
    html: true,
    placement: "left",
    trigger: "manual",
    title: false,
    content: ->
      '<div id="picker">
        <div id="datepicker" data-start="' + data_start + '" data-end="' + data_end + '"></div>
        <a id="dp_prev"><i class="icon-chevron-left"></i></a>
        <a id="dp_next"><i class="icon-chevron-right"></i></a>
      </div>'
  })
  
  $('#daterange-select').click ->
    poppedOver = $(this).next('div.popover:visible').length
    if (poppedOver)
      $(".picker-container").html($(".popover-content").html())
      $(this).popover('hide')
    else
      $(this).popover('show')
      setup_daterange_selector()
  
  update_rails_datetime_select = (id, time, start_end) ->
    trailing_zero = (num) ->
      if (num < 9) then ("0" + (num + 1).toString()) else (num + 1)
    
    $(id + "_3i}").val(time.getDate())
    $(id + "_2i}").val(trailing_zero(time.getMonth()))
    $(id + "_1i}").val(1900 + time.getYear())
    
    if (start_end == "start")
      $(id + "_4i").val("00")
      $(id + "_5i").val("00")
    else
      $(id + "_4i").val("23")
      $(id + "_5i").val("59")
  
  # # for future reference
  # $('.destroy-domain').click () -> 
  #   hidden_field = $(this).siblings('input[name$="[_destroy]"][type=hidden]')
  #   hidden_field.val(1)
  #   $(this).closest("form").submit()