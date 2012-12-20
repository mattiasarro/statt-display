//= require jquery.ui.core
//= require jquery.ui.datepicker
//= require jquery.ui.selectable
//= require daterange_selector

$(document).ready () ->
  $('.destroy-domain').click () -> 
    hidden_field = $(this).siblings('input[name$="[_destroy]"][type=hidden]')
    hidden_field.val(1)
    $(this).closest("form").submit()
  
  
  
  update_rails_datetime_select = (id, time) ->
    trailing_zero = (num) ->
      if (num < 9) then ("0" + (num + 1).toString()) else (num + 1)

    $(id + "_3i}").val(time.getDate())
    $(id + "_2i}").val(trailing_zero(time.getMonth()))
    $(id + "_1i}").val(1900 + time.getYear())
  
  DaterangeSelector({
    selector: "#datepicker", 
    nr_months: 2,
    start_date: (time) -> (
      update_rails_datetime_select("#graph_from", time)
    ),
    end_date: (time) -> (
      update_rails_datetime_select("#graph_to", time)
    )
  })