Display.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set('title', "my app")