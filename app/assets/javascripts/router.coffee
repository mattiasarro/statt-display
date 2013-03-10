Display.Router.map ->
  @route "site", path: '/'
  @resource "loads", path: '/loads', ->
    @route "list", path: '/show' # expanded tooltip

Display.SiteRoute = Ember.Route.extend
  setupController: (controller, site) ->
    controller.set('site_name', "Sample Site")
    controller.set('content', site)
  model: (params) ->
    # Display.Site.find(params.site_id)
    {site_id: "50d6549e1b47f8a410000002"}
