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
  
  bar_duration: (->
    7199
  ).property("nrBars")
  

# TODO: set property("") dependencies    
Statt.BarController = Ember.ObjectController.extend
  needs: "chart"
  chart: 
    width: 938 # including padding
    height: 193 # including padding
    padding: 10
    nr_bars: 60
    bar_duration: 7199
  timeframe: # this will get dynamic
    from: 1366758000
    timeframe_duration: 431940
    max_value: 450
  x: (-> 
    @xScale()(@get("time") - @get("timeframe.from"))
  ).property()
  
  y: (->
    @parentController.height - @yScale()(@get("value")) - 1
  ).property()
  
  width: (->
    (@parentController.width - (2 * @chart.padding)) / @parentController.nrBars
  ).property()
  
  height: (->
    @yScale()(@get("value"))
  ).property()
  
  xScale: ->
    d3.scale.linear() # index * bar_width
    .domain([0, @chart.bar_duration])
    .range([@chart.padding, @get("width") + @chart.padding])
  
  yScale: ->
    d3.scale.linear()
    .domain([0, @timeframe.max_value])
    .rangeRound([@chart.padding, @chart.height])
  


  