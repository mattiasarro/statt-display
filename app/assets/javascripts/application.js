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
//= require patches
//= require daterange_selector
//= require_self
//= require ./statt
//= require graph_rendering
//= require graph_daterange
Statt = Ember.Application.create({
  LOG_TRANSITIONS: true
});
// these will not work at the moment, waiting to be refactored into the Ember-based system
//= require ./graph_daterange
//= require ./graph_rendering
//= require ./loads