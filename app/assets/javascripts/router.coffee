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
    

Statt.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set('title', "my app")
  

Statt.SiteRoute = Ember.Route.extend
  setupController: (controller, site_model) ->
    controller.set('site_name', "Sample Site")
    controller.set('content', site_model)
  
  model: (params) ->
    # Statt.Site.find()
    {id: params.site_id}
  


Statt.LoadsRoute = Ember.Route.extend
  setupController: (controller,model) ->
    console.log("LoadsRoute::setupController")
    controller.set("content", model)
    controller.set("loadsTabActive", true)
    
  model: (params) ->
    console.log("LoadsRoute::model")
    Ember.Object.create
      nr_pages: 12 
      pages: [
        {nr: 1}
        {nr: 2}
        {nr: 3}
      ]
    

Statt.LoadsIndexRoute = Ember.Route.extend
  redirect: () -> @transitionTo("loads.page", @get("pagination.page_nr"))
  
Statt.VisitorsIndexRoute = Ember.Route.extend
  redirect: () -> @transitionTo("visitors.page", @get("pagination.page_nr"))

Statt.LoadsPageRoute = Ember.Route.extend
  setupController: (controller, model) ->
    console.log("LoadsPageRoute::setupController")
    controller.set('content', model)
    @controllerFor("loads").set("page_nr", model.page_nr)
    
  model: (params) ->
    console.log("LoadsPageRoute::model")
    # m = @site.graph.loads_pagination(params.page_nr)
    Ember.Object.create
      nr_pages: 12
      page_nr: params["page_nr"]
      load_cols: [
        [
          {time: "1", top: "asdf"}
          {time: "2", top: "asdf"}
        ]
        [
          {time: "3", top: "asdf"}
          {time: "4", top: "asdf"}
        ]
        [
          {time: "5", top: "asdf"}
          {time: "6", top: "asdf"}
        ]
      ]
    # Statt.LoadsPage.find(params.page_nr)
  

Statt.VisitorsIndexRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set('content', model)
  
  renderTemplate: ->
    @render(
      "bottom_tab"
      outlet: "bottom_tab"
    )
    @render(
      "visitors.index",
      into: "bottom_tab"
    )
  model: (params) ->
    m = {
      pagination: {
        page_nr: 3
        nr_pages: 8
      }
    }
  
  
