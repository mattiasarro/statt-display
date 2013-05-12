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
  
  mock_params: {
    site_id: "5168608d763c55ea58000003"
    graph: {
      nr_bars: 60
      type: "custom"
    }
    timeframe: {
      "from(3i)": "24"
      "from(2i)": "4" 
      "from(1i)": "2013"
      "from(4i)": "00"
      "from(5i)": "00"
      "to(3i)": "28"
      "to(2i)": "4"
      "to(1i)": "2013"
      "to(4i)": "23"
      "to(5i)": "59"
    }
  }
  getLoadsModel: (page_nr) ->
    controller = @controllerFor("loads.page")
    controller.set("pageNr", page_nr)
    p = @mock_params
    p.loads_pg_nr = page_nr
    loads = Statt.Load.find(p)
    loads.set("pageNr", page_nr)

Statt.LoadsPageRoute = Ember.Route.extend
  renderTemplate: ->
    @render({into: "chart"})
  
  serialize: (model) ->
    {page_nr: model.pageNr}
  
  mock_params: {
    site_id: "5168608d763c55ea58000003"
    graph: {
      nr_bars: 60
      type: "custom"
    }
    timeframe: {
      "from(3i)": "24"
      "from(2i)": "4" 
      "from(1i)": "2013"
      "from(4i)": "00"
      "from(5i)": "00"
      "to(3i)": "28"
      "to(2i)": "4"
      "to(1i)": "2013"
      "to(4i)": "23"
      "to(5i)": "59"
    }
  }
  model:  (params)  -> @setupModel(params.page_nr)
  events:
    goto: (page_nr) -> @setupModel(page_nr, true)
  setupModel: (page_nr, transition = false) ->
    controller = @controllerFor("loads.page")
    controller.set("pageNr", page_nr)
    p = @mock_params
    p.loads_pg_nr = page_nr
    loads = Statt.Load.find(p)
    loads.set("pageNr", page_nr)
    if transition then @transitionTo("loads.page", loads) else loads
  