//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap

# bootstrap
jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()