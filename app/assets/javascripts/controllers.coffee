DEBUG = true

Statt.LoadsPageController = Ember.ObjectController.extend
  loadColumnsWithIndices: (() ->
    console.log("LoadsPageController::loadColumnsWithIndices") if DEBUG
    decorate_loads = (col) ->
      top = (load) ->
        if load.time_on_page
          load.time_on_page + " seconds"
        else
          till_now = new Date() - new Date(load.time)
          if till_now < 360
            till_now + " seconds"
          else
            "unknown"
      
      col.map (load_item, index, enumerable) ->
        load_item.time = new Date(load_item.time).time()
        load_item.background = "background: #" + load_item.color + ";"
        load_item.top = top(load_item)
        load_item
    
    cols = @get("content.load_cols")
    # return [] unless cols
    cols.map(
      (item,index, enumerable) ->
        item: decorate_loads(item)
        first: (index == 0)
    
    )).property('content.load_cols')
  