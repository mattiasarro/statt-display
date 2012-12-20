//= require jquery.ui.core
//= require jquery.ui.datepicker
//= require jquery.ui.selectable
//= require daterange_selector

$(document).ready () ->
  $('.destroy-domain').click () -> 
    hidden_field = $(this).siblings('input[name$="[_destroy]"][type=hidden]')
    hidden_field.val(1)
    $(this).closest("form").submit()
  
  DaterangeSelector({
    selector: "#datepicker", 
    nr_months: 2,
    start_date: (time) -> (
      console.log("Start date set: " + time)
    ),
    end_date: (time) -> (
      console.log("End date set:" + time)
    )
  })