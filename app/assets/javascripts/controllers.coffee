DEBUG = true

Statt.LoadsIndexController = Ember.ArrayController.extend
  something: 1

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
  

# no need to set property("keys"), values never updated
Statt.BarController = Ember.ObjectController.extend
  needs: "chart"
  chart: -> @parentController
  x: (-> 
    @get("xScale")(@get("time") - @chart().get("from"))
  ).property()
  
  y: (->
    @chart().height - @get("yScale")(@get("value")) - 1
  ).property()
  
  width: (->
    (@chart().width - (2 * @chart().padding)) / @chart().nrBars
  ).property()
  
  height: (->
    @get("yScale")(@get("value"))
  ).property()
  
  xScale: (->
    d3.scale.linear() # index * bar_width
    .domain([0, @chart().get("barDuration")])
    .range([@chart().padding, @get("width") + @chart().padding])
  ).property().cacheable()
  
  yScale: (->
    d3.scale.linear()
    .domain([0, @chart().get("maxLoads")])
    .rangeRound([@chart().padding, @chart().height])
  ).property().cacheable()
  
  labelX: (->
    @get("x") + 2
  ).property()
  
  labelY: (->
    @get("y") + 10
  ).property()
  