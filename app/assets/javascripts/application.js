// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require handlebars
//= require ember
//= require ember-data
//= require d3
//= require_self
//= require ./statt
Statt = Ember.Application.create({
  LOG_TRANSITIONS: true
});
$(document).ready(function () {
  $("a[rel=popover]").popover();
  $(".tooltip").tooltip();
  $("a[rel=tooltip]").tooltip();
});
// these will not work at the moment, waiting to be refactored into the Ember-based system
//= require ./graph_daterange
//= require ./graph_rendering
//= require ./loads