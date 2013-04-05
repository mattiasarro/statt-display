Statt.Router.map ->
  @resource "site", path: '/sites/:site_id', ->
    @resource "loads", path: '/loads', ->
      @route "page", path: "/page/:page_nr"
      @route "show", path: '/show' # expanded tooltip
    
    @resource "visitors", path: '/visitors/:page_nr', ->
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
  

Statt.LoadsIndexRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set('content', model)
  
  renderTemplate: ->
    @render(
      into: "site"
      outlet: "bottomcontent"
    )
  
  model: (params) ->
    # m = @site.graph.loads_pagination(params.page_nr)
    m = {
      some: [1,2,3]
      pagination: {
        page_nr: 1 # params.page_nr
        nr_pages: 16
      }
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
  

Statt.LoadsPageRoute = Ember.Route.extend
  setupController: (controller, model) ->
    console.log("asdf")
    controller.set("something", "overwrite")
    controller.set('content', model)
  
  model: (params) ->
    console.log("asdfasdf")
    # m = @site.graph.loads_pagination(params.page_nr)
    m = {
      pagination: {
        page_nr: 1 # params.page_nr
        nr_pages: 16
      }
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
  
  
