$(document).ready () ->
  $('.visitor').click () -> 
    id = $(this).data 'id'
    $("#visitor-#{id}-loads").toggle()