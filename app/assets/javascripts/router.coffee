Display.Router.map ->
  @resource "site", path: '/sites/:site_id'
  @resource "loads", path: '/loads', ->
    @route "list", path: '/show' # expanded tooltip

Display.SiteRoute = Ember.Route.extend
  setupController: (controller, site) ->
    controller.set('site_name', "Sample Site")
    controller.set('content', site)
  model: (params) ->
    # Display.Site.find()
    {site_id: params.site_id}
