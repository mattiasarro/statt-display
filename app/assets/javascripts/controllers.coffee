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
  needs: "loads"
  loadsTabActive: "true"

Statt.LoadsController = Ember.ObjectController.extend
  needs: "loads.page"

Statt.LoadsPageController = Ember.ObjectController.extend
  #loadsTabActive: "asdf"
  needs: "loads"
  loadColumnsWithIndices: (() ->
    console.log("LoadsPageController::loadColumnsWithIndices")
    console.log(@get("content"))
    
    cols = @get("content.load_cols")
    # return [] unless cols
    cols.map(
      (item,index, enumerable) ->
        item: item
        first: (index == 0)
    
    )).property('content.load_cols')
  
Statt.VisitorsIndexController = Ember.ObjectController.extend
  visitorsTabActive: true

Statt.PaginationController = Ember.ObjectController.extend
