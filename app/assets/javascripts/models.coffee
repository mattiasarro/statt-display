Statt.Site = DS.Model.extend
  site_id: DS.attr("string")
  didCreate: -> (console.log "yes")
  didLoad: -> (console.log "mhm")

Statt.LoadsPage = DS.Model.extend
  earliestLoadTime: DS.attr("number")
  latestLoadTime: DS.attr("number")
  pageNr: DS.attr("number")
  nrPages: DS.attr("number")
  loads: DS.hasMany("Statt.Load")
  load_cols: [[{"path":"p","time":"2013-04-26T19:46:35Z","color":"608c84","time_on_page":null,"user_agent":"ua","title":"t"}]]
  didCreate: -> (console.log "did create")
  didLoad: -> (console.log "did load")
  
  
  
Statt.Load = DS.Model.extend
  page: DS.belongsTo("Statt.LoadsPage")