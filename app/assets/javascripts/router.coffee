DEBUG = true
Statt.Router.map ->
  @resource "site", path: '/sites/:site_id', ->
    @resource "chart", path: "/chart/:nr_bars/:from/:to", ->
      @resource "loads", path: '/loads/:page_nr', ->
        # implicit index
      @resource "visitors", path: "/visitors/:page_nr", ->
        # implicit index

Statt.ChartRoute = Ember.Route.extend
  model: (params) ->
    cc = @controllerFor("chart")
    cc.set("nrBars", params.nr_bars)
    cc.set("from", params.from)
    cc.set("to", params.to)
    Statt.Bar.find({nr_bars: params.nr_bars, from: params.from, to: params.to})

Statt.LoadsIndexRoute = Ember.Route.extend
  setupController: (controller,model) ->
    controller.set("content", model)
    controller.set("pageNr", 13)
    controller.set("nrPages", 60)
    controller.set("pages", [{id: 1, nr: 1}, {id: 2, nr: 2}])
  
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
  model: (params) ->
    p = @mock_params
    p.loads_pg_nr = params.page_nr
    Statt.Load.find(p)
  
  renderTemplate: -> 
    @render({
      into: "chart"
      outlet: "bottom"
    })
  
