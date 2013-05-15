Statt.ChartController = Ember.ArrayController.extend
  itemController: "bar"
  needs: "loads.page"
  width: 938 # including padding
  height: 193 # including padding
  padding: 10
  transform: (->
    "translate(" + @padding + ", " + @padding + ")"
  ).property()
  
  chartDuration: (->
    @get("content.to") - @get("content.from")
  ).property("content.to", "content.from")
  
  barDuration: (->
    (@get("content.to") - @get("content.from")) / @get("content.nrBars")
  ).property("content.nrBars", "content.from", "content.to")
  
  barWidth: (->
    (@width - (2 * @padding)) / @get("content.nrBars")
  ).property("content.nrBars").cacheable()
  
  fromStr: (->
    f = new Date(@get("content.from") * 1000)
    f.full()
  ).property("content.from")
  
  toStr: (->
    f = new Date(@get("content.to") * 1000)
    f.full()
  ).property("content.to")
  
  maxLoads: (->
    @reduce((previousValue, item) ->
      if previousValue > item.get("value")
        previousValue
      else
        item.get("value")
    )
  ).property("@each.value")
  
  highlightX: (->
    #@get("xScale")(earliest_load_time - @get("from")) - .5
    532.7094179747188
  ).property()
  
  highlightY: (->
    -11
  ).property()  
  
  highlightWidth: (->
    30
  ).property()
  
  highlightHeight: (->
    203
  ).property()
  
  xScale: (->
    d3.scale.linear() # index * bar_width
    .domain([0, @get("barDuration")])
    .range([@padding, @get("barWidth") + @padding])
  ).property("barDuration", "barWidth").cacheable()
  
  yScale: (->
    d3.scale.linear()
    .domain([0, @get("maxLoads")])
    .rangeRound([@padding, @height])
  ).property("maxLoads").cacheable()
  
  nrLoads: (->
    sumLoadNumbers = (previousValue, item) ->
      previousValue = previousValue + item.get("value")
    @reduce(sumLoadNumbers, 0)
  ).property("@each.value")
  

Statt.BarController = Ember.ObjectController.extend
  needs: "chart"
  chart: -> @parentController
  x: (-> 
    scale = @chart().get("xScale")
    scale(@get("time") - @chart().get("content.from"))
  ).property()
  
  y: (->
    scale = @chart().get("yScale")
    @chart().height - scale(@get("value")) - 1
  ).property()
  
  width: (->
    @chart().get("barWidth")
  ).property()
  
  height: (->
    scale = @chart().get("yScale")
    scale(@get("value"))
  ).property()
  
  labelX: (->
    @get("x") + 2
  ).property()
  
  labelY: (->
    @get("y") + 10
  ).property()
  
Statt.PageLink = Ember.Object.extend
  active: ->
    console.log this
    
  

Statt.LoadsPageController = Ember.ArrayController.extend
  needs: "chart"
  perPage: 30
  nrPages: (->
    nr_loads = @get("controllers.chart.nrLoads")
    Math.ceil(nr_loads / @perPage)
  ).property("controllers.chart.nrLoads")
  
  windows: (->
    nr_pages = (Number) @get("nrPages")
    current_pg = (Number) parseInt(@get("content.pageNr"))
    first_pg_of_tail = nr_pages - 2
    
    get_window = (range) ->
      page_obj = (pg) ->
        Ember.Object.create
          id: pg
          active: (current_pg == pg)
      
      pages  = (page_obj pg for pg in range)
      window = Ember.Object.create({pages: pages})
    
    if nr_pages <= 13
      if nr_pages > 1
        arr = [get_window([1..nr_pages])]
      else
        arr = []
    else if current_pg in [1..6]
      arr = [
        get_window([1..8])
        get_window([(nr_pages-2)..nr_pages])
      ]
    else if current_pg in [7..(nr_pages-5)]
      arr = [
        get_window([1..3])
        get_window([(current_pg-2)..(current_pg+2)])
        get_window([(nr_pages-2)..nr_pages])
      ]
    else if current_pg in [(nr_pages-6)..nr_pages]
      arr = [
        get_window([1..3])
        get_window([(nr_pages-7)..nr_pages])
      ]
    else
      console.log("ERROR getting pagination sliding windows")
    
    arr
  ).property("nrPages", "content.pageNr")
  
  loadColsWithIndex: (->
    @get("loadCols").map(
      (col,i) ->
        col: col
        first: (i == 0)
    )
  ).property("@each")
  
  loadCols: (->
    [
      @get("content")[0...10]
      @get("content")[10...20]
      @get("content")[20...30]
    ]
  ).property("@each")
  

Statt.PaginationController = Ember.ArrayController.extend
  itemController: "page"

Statt.PageController = Ember.ObjectController.extend
  needs: ["loads_page", "site", "chart"]
  active: (->
    activePage  = (Number) @get("controllers.loads_page.content.pageNr")
    currentPage = (Number) @get("id")
    activePage == currentPage
  ).property()
  