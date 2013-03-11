Display.Router.map ->
  @resource "site", path: '/sites/:site_id', ->
    @resource "loads", path: '/loads/:page_nr', ->
      @route "show", path: '/show' # expanded tooltip
    
    @resource "visitors", path: '/visitors/:page_nr', ->
      @route "show", path: '/show' # dunno really
    

Display.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set('title', "my app")
  

Display.SiteRoute = Ember.Route.extend
  setupController: (controller, site) ->
    controller.set('site_name', "Sample Site")
    controller.set('content', site)
  
  model: (params) ->
    # Display.Site.find()
    {id: params.site_id}
  

Display.LoadsIndexRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set('active', true)
    controller.set('content', model)
  
  model: (params) ->
    # m = @site.graph.loads_pagination(params.page_nr)
    m = {
      id: 8
      page_nr: params.page_nr
      nr_pages: 16
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
    }
  
