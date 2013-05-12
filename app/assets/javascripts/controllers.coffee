Statt.ChartController = Ember.ArrayController.extend
  itemController: "bar"
  needs: "loads.page"
  width: 938 # including padding
  height: 193 # including padding
  padding: 10
  transform: (->
    "translate(" + @padding + ", " + @padding + ")"
  ).property()
  
  barDuration: (->
    (@get("to") - @get("from")) / @get("nrBars")
  ).property("nrBars", "from", "to")
  
  fromStr: (->
    f = new Date(@get("from") * 1000)
    f.full()
  ).property("from")
  
  toStr: (->
    f = new Date(@get("to") * 1000)
    f.full()
  ).property("to")
  
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
  
  barWidth: (->
    (@width - (2 * @padding)) / @nrBars
  ).property().cacheable()
  
  xScale: (->
    d3.scale.linear() # index * bar_width
    .domain([0, @get("barDuration")])
    .range([@padding, @get("barWidth") + @padding])
  ).property().cacheable()
  
  yScale: (->
    d3.scale.linear()
    .domain([0, @get("maxLoads")])
    .rangeRound([@padding, @height])
  ).property().cacheable()
  
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
    scale(@get("time") - @chart().get("from"))
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
  

Statt.LoadsPageController = Ember.ArrayController.extend
  needs: "chart"
  perPage: 30
  nrPages: (->
    nr_loads = @get("controllers.chart.nrLoads")
    Math.ceil(nr_loads / @perPage)
  ).property("controllers.chart.nrLoads")
  
  pages: (->
    Ember.Object.create {id: nr} for nr in [1..5]
  ).property()
  
  loadColsWithIndex: (->
    @get("loadCols").map(
      (col,i) ->
        col: col
        first: (i == 0)
    )
  ).property()
  
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
  needs: "loads_page"
  active: (->
    activePage  = (Number) @get("controllers.loads_page").get("pageNr")
    currentPage = (Number) @get("id")
    activePage == currentPage
  ).property()
  