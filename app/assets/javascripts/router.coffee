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
  

Statt.SiteRoute = Ember.Route.extend
  setupController: (controller, site_model) ->
    controller.set('site_name', "Sample Site")
    controller.set('content', site_model)
  
  model: (params) ->
    # Statt.Site.find()
    {id: params.site_id}
  


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
  redirect: () -> @transitionTo("loads.page", @get("pagination.page_nr"))

Statt.LoadsPageRoute = Ember.Route.extend
  setupController: (controller, model) ->
    console.log("LoadsPageRoute::setupController") if DEBUG
    controller.set('content', model)
    @controllerFor("loads").set("page_nr", model.page_nr)
    
  model: (params) ->
    console.log("LoadsPageRoute::model") if DEBUG
    # m = @site.graph.loads_pagination(params.page_nr)
    Statt.LoadsPage.find(1, {id: params.page_nr})
    Ember.Object.create
      nr_pages: 12
      page_nr: params["page_nr"]
      load_cols: loads_page.loads
