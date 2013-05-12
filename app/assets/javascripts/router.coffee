DEBUG = true
Statt.Router.map ->
  @resource "site", path: '/sites/:site_id', ->
    @resource "chart", path: "/chart/:nr_bars/:from/:to", ->
      @resource "loads", path: '/loads', ->
        @route "page", path: '/page/:page_nr'
        # last page (that would redirect)
      @resource "visitors", path: "/visitors", ->
        @route "page", path: '/page/:page_nr'

Statt.SiteRoute = Ember.Route.extend
  model: (params) ->
    Statt.site_id = params.site_id # TODO: make RESTful
    {id: params.site_id}
  

Statt.ChartRoute = Ember.Route.extend
  renderTemplate: ->
    @render({into: "application"})
  
  serialize: (model) ->
    { nr_bars: model.nrBars, from: model.from, to: model.to }
  
  model: (params) ->
    @getModel(params)
  
  events:
    prev: ->
      controller = @controllerFor("chart")
      nrBars = controller.get("content.nrBars")
      from = controller.get("content.from") - controller.get("chartDuration")
      to = controller.get("content.to") - controller.get("chartDuration")

      chart = @getModel({nr_bars: nrBars, from: from, to: to})
      @transitionTo("loads.page", chart, @getLoadsModel(1))
    
    next: ->
      controller = @controllerFor("chart")
      nrBars = controller.get("content.nrBars")
      from = controller.get("content.from") + controller.get("chartDuration")
      to = controller.get("content.to") + controller.get("chartDuration")

      chart = @getModel({nr_bars: nrBars, from: from, to: to})
      @transitionTo("loads.page", chart, @getLoadsModel(1))
    
  getModel: (params) ->
    p = {nr_bars: params.nr_bars, from: params.from, to: params.to, site_id: Statt.site_id}
    chart = Statt.Bar.find(p)
    chart.set("nrBars", parseInt(params.nr_bars))
    chart.set("from", parseInt(params.from))
    chart.set("to", parseInt(params.to))
    chart
  
  
  
  getLoadsModel: (page_nr) ->
    params = {
        site_id: Statt.site_id
        from: @modelFor("chart").get("from")
        to: @modelFor("chart").get("to")
        loads_pg_nr: page_nr
    }
    loads = Statt.Load.find(params)
    loads.set("pageNr", page_nr)
  

Statt.LoadsPageRoute = Ember.Route.extend
  renderTemplate: ->
    @render({into: "chart"})
  
  serialize: (model) ->
    {page_nr: model.pageNr}
  
  paramsBase: ->
    {
      site_id: Statt.site_id
      from: @modelFor("chart").get("from")
      to: @modelFor("chart").get("to")
    }
  
  model:  (params)  -> 
    console.log params
    @setupModel(params.page_nr)
  events:
    goto: (page_nr) -> @setupModel(page_nr, true)
  setupModel: (page_nr, transition = false) ->
    p = @paramsBase()
    p.loads_pg_nr = page_nr
    loads = Statt.Load.find(p)
    loads.set("pageNr", page_nr)
    if transition then @transitionTo("loads.page", loads) else loads
  