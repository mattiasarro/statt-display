DEBUG = true
Statt.Router.map ->
  @resource "site", path: '/sites/:site_id', ->
    @resource "chart", path: "/chart/:nr_bars/:from/:to", ->
      @resource "loads", path: '/loads', ->
        @route "page", path: '/page/:page_nr'
        # implicit index
      @resource "visitors", path: "/visitors/:page_nr", ->
        # implicit index

Statt.SiteRoute = Ember.Route.extend()

Statt.ChartRoute = Ember.Route.extend
  model: (params) ->
    cc = @controllerFor("chart")
    cc.set("nrBars", params.nr_bars)
    cc.set("from", params.from)
    cc.set("to", params.to)
    ret = Statt.Bar.find({nr_bars: params.nr_bars, from: params.from, to: params.to})
    ret.set("nrBars", params.nr_bars)
    ret.set("from", params.from)
    ret.set("to", params.to)
    ret
  serialize: (model) ->
    { nr_bars: model.nrBars, from: model.from, to: model.to }

Statt.LoadsPageRoute = Ember.Route.extend
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
  model:  (params) -> @setupModel(params.page_nr)
  events:
    goto: (page_nr) -> @setupModel(page_nr, true)
  setupModel: (page_nr, transition = false) ->
    controller = @controllerFor("loads.page")
    controller.set("pageNr", page_nr)
    p = @mock_params
    p.loads_pg_nr = page_nr
    loads = Statt.Load.find(p)
    if transition then @transitionTo("loads.page", loads) else loads
  
