Statt.Site = DS.Model.extend
  onetwo: DS.attr("string")

Statt.Timeframe = Ember.Object.extend
  init: (fromInt, toInt) ->
    @set "from", (new Date(fromInt * 1000))
    @set "to", (new Date(toInt * 1000))

Statt.Bar = DS.Model.extend
  #from: DS.attr("date")
  #to: DS.attr("date")
  #nrLoads: DS.attr("number")
  #nrVisitors: DS.attr("number")
  time: DS.attr("number")
  value: DS.attr("number")

Statt.Load = DS.Model.extend
  title: DS.attr("string")
  path: DS.attr("string")
  userAgent: DS.attr("string")
  clUserId: DS.attr("string")
  time: DS.attr("number")
  color: DS.attr("string")
  timeStr: (-> 
    new Date(@get("time") * 1000).time()
  ).property()
  
  timeOnPageStr: (->
    if @get("timeOnPage")
      @get("timeOnPage") + " seconds"
    else
      till_now = new Date() - new Date(@get("time")*1000)
      if till_now < 360
        till_now + " seconds"
      else
        "unknown"
  ).property()
  
  background: (->
    "background: #" + @get("color") + ";"
  ).property("color")
  

Statt.Page = DS.Model.extend
  nr: DS.attr("number")