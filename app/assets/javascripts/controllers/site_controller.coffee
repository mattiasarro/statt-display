Display.SiteController = Ember.ObjectController.extend
  who: "site"
  whoelse: "site2"
  setupController: (controller) -> 
    controller.set('content', {one: "two"})