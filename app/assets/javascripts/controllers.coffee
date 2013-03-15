Statt.ApplicationController = Ember.Controller.extend
  who: "me"

Statt.SiteController = Ember.ObjectController.extend
  graph: {
    nr_bars: 60
    bar_duration: 60
    max_value: 16
  }
  timeframe: {
    from:  1356220740
    to: 1356224340
    duration: 3600
  }

Statt.LoadsIndexController = Ember.ObjectController.extend
  something: "default"

Statt.PaginationController = Ember.ObjectController.extend