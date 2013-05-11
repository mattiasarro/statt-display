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