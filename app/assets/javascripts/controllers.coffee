DEBUG = true

Statt.LoadsIndexController = Ember.ArrayController.extend
  foo: "bar"

Statt.ChartController = Ember.ArrayController.extend
  itemController: "bar"
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
  ).property("@each.item")
  
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
  
# no need to set property("keys"), values never updated
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
  