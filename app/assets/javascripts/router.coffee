DEBUG = false
Statt.Router.map ->
  @resource "site", path: '/sites/:site_id', ->
    
    @resource "loads", path: '/loads', ->
      # implicit /index
      @route "page", path: "/page/:page_nr"
      @route "show", path: '/show' # expanded tooltip
    
    @resource "visitors", path: '/visitors', ->
      # implicit /index
      @route "page", path: "/page/:page_nr"
      @route "show", path: '/show' # dunno really

Statt.LoadsRoute = Ember.Route.extend
  setupController: (controller,model) ->
    console.log("LoadsRoute::setupController") if DEBUG
    controller.set("content", model)
    controller.set("loadsTabActive", true)
    
  model: (params) ->
    console.log("LoadsRoute::model") if DEBUG
    Ember.Object.create
      nr_pages: 12 
      pages: [
        {nr: 1}
        {nr: 2}
        {nr: 3}
      ]
    

Statt.LoadsIndexRoute = Ember.Route.extend
  redirect: () -> @transitionTo("loads.page", @get("pagination.pageNr"))

Statt.LoadsPageRoute = Ember.Route.extend
  setupController: (controller, model) ->
    console.log("LoadsPageRoute::setupController") if DEBUG
    controller.set('content', model)
    @controllerFor("loads").set("pageNr", model.pageNr)
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
    console.log("LoadsPageRoute::model") if DEBUG
    p = @mock_params
    p.loads_pg_nr = params.page_nr
    ret = Statt.LoadsPage.find(p)
    ret.load_cols = loads_page.loads
    ret
    
