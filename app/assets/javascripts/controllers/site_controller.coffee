Display.SiteController = Ember.ObjectController.extend
  
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
  bottom_tab: {
    active: "Loads"
    Loads: {
      page_nr: 8
      nr_pages: 16
    }
    Visitors: {
      page_nr: 2
      nr_pages: 6
    }
  }
  load_cols: [
    [
      {time: "1", top: "asdf"}
      {time: "2", top: "asdf"}
    ]
    [
      {time: "3", top: "asdf"}
      {time: "4", top: "asdf"}
    ]
    [
      {time: "5", top: "asdf"}
      {time: "6", top: "asdf"}
    ]
  ]
  
  changeBottomTab: (tab_id) ->
    @bottom_tab.active = tab_id
    console.log("bottom_tab: " + tab_id)
    @draw_pagination()
  
  draw_pagination: ->
    tab_id = @bottom_tab.active
    console.log(@bottom_tab)
    page_nr = @bottom_tab[tab_id]["page_nr"]
    nr_pages = @bottom_tab[tab_id]["nr_pages"]
    console.log("pagination for: " + tab_id)
    console.log("  page_nr: " + page_nr)
    console.log("  nr_pages: " + nr_pages)

