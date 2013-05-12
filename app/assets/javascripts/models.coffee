Statt.Site = DS.Model.extend
  onetwo: DS.attr("string")

Statt.Bar = DS.Model.extend
  #from: DS.attr("date")
  #to: DS.attr("date")
  #nrLoads: DS.attr("number")
  #nrVisitors: DS.attr("number")
  time: DS.attr("number")
  value: DS.attr("number")

Statt.Load = DS.Model.extend
  path: DS.attr("string")
  user_agent: DS.attr("string")
  time: DS.attr("number")
  color: DS.attr("string")
  timeStr: (-> 
    new Date(@get("time") * 1000).time()
  ).property()
  timeOnPage: (-> 
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
  ).property()
  

Statt.Page = DS.Model.extend
  nr: DS.attr("number")
  active: ->
    false
