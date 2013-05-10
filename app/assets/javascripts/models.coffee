Statt.Site = DS.Model.extend
  onetwo: DS.attr("string")

Statt.LoadsPage = DS.Model.extend
  earliestLoadTime: DS.attr("number")
  latestLoadTime: DS.attr("number")
  pageNr: DS.attr("number")
  nrPages: DS.attr("number")
  pages: (-> 
    [{nr: 1}, {nr: 2}, {nr: 3}]
  ).property("nrPages", "pageNr")
  #loads: DS.hasMany("Statt.Load")
  #load_cols: [[{"path":"p","time":"2013-04-26T19:46:35Z","color":"608c84","time_on_page":null,"user_agent":"ua","title":"t"}]]
  didLoad: ->
    console.log "did load LOADS PAGE"
    console.log @get("pageNr")
    console.log @get("nrPages")
 
#Statt.Load = DS.Model.extend
#  page: DS.belongsTo("Statt.LoadsPage")