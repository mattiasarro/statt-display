Statt.Site = DS.Model.extend
  onetwo: DS.attr("string")

Statt.Bar = DS.Model.extend
  #from: DS.attr("date")
  #to: DS.attr("date")
  #nrLoads: DS.attr("number")
  #nrVisitors: DS.attr("number")
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
  time: DS.attr("number")
  value: DS.attr("number")
  x: (-> 
    @xScale()(@get("time") - @get("timeframe.from"))
  ).property()
  
  y: (->
    @chart.height - @yScale()(@get("value")) - 1
  ).property()
  
  width: (->
    @bar_width()
  ).property()
  
  height: (->
    @yScale()(@get("value"))
  ).property()
  
  xScale: ->
    d3.scale.linear() # index * bar_width
    .domain([0, @chart.bar_duration])
    .range([@chart.padding, @bar_width() + @chart.padding])
  
  yScale: ->
    d3.scale.linear()
    .domain([0, @timeframe.max_value])
    .rangeRound([@chart.padding, @chart.height])
  
  bar_width: ->
    (@chart.width - (2 * @chart.padding)) / @chart.nr_bars
  

Statt.Load = DS.Model.extend
  path: DS.attr("string")
  user_agent: DS.attr("string")

Statt.Page = DS.Model.extend
  nr: DS.attr("number")
  active: ->
    false

Statt.LoadsPage = DS.Model.extend
  earliestLoadTime: DS.attr("number") # compute in a function
  latestLoadTime: DS.attr("number") # compute in a function
  pageNr: DS.attr("number") # take from params
  nrPages: DS.attr("number") # ??
  #loads: DS.hasMany("Statt.Load")
  #load_cols: [[{"path":"p","time":"2013-04-26T19:46:35Z","color":"608c84","time_on_page":null,"user_agent":"ua","title":"t"}]]
  didLoad: ->
    console.log "did load LOADS PAGE"
    console.log @get("pageNr")
    console.log @get("nrPages")
    console.log this
 
#Statt.Load = DS.Model.extend
#  page: DS.belongsTo("Statt.LoadsPage")