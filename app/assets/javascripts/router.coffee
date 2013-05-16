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
    timeframe = new Statt.Timeframe(parseInt(params.from), parseInt(params.to))
    @controllerFor("chart").set("timeframe", timeframe)
    chart = Statt.Bar.find(p)
    chart.set("nrBars", parseInt(params.nr_bars))
    chart.set("from", parseInt(params.from))
    chart.set("to", parseInt(params.to))
    chart
  
  getLoadsModel: (page_nr) ->
    params = {
        from: @modelFor("chart").get("from")
        to: @modelFor("chart").get("to")
        loads_pg_nr: page_nr
    }
    Statt.getLoads(params, @controllerFor("chart"))
  
Statt.getLoads = (params, chartController) ->
  params.site_id = Statt.site_id
  loads = Statt.Load.find(params)
  loads.set("pageNr", params.loads_pg_nr)
  loads.on "didLoad", ->
    firstLoad = @get("content")[0].record
    lastLoad = @get("content")[@get("content").length - 1].record
    chartController.set("firstLoad", firstLoad)
    chartController.set("lastLoad", lastLoad)
    
Statt.LoadsPageRoute = Ember.Route.extend
  renderTemplate: ->
    @render({into: "chart"})
  
  serialize: (model) ->
    {page_nr: model.pageNr}
  
  model:  (params)  ->
    @setupModel(params.page_nr)
  events:
    goto: (page_nr) -> @setupModel(page_nr, true)
  setupModel: (page_nr, transition = false) ->
    params = {
      from: @modelFor("chart").get("from")
      to: @modelFor("chart").get("to")
      loads_pg_nr: page_nr
    }
    loads = Statt.getLoads(params, @controllerFor("chart"))
    if transition then @transitionTo("loads.page", loads) else loads
  