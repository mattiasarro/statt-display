$(document).ready () ->
  $('.destroy-domain').click () -> 
    hidden_field = $(this).siblings('input[name$="[_destroy]"][type=hidden]')
    hidden_field.val(1)
    $(this).closest("form").submit()