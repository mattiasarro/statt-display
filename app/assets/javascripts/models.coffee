Statt.Site = DS.Model.extend
  onetwo: DS.attr("string")

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