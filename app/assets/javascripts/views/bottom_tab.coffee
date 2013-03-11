Display.BottomTab = Ember.View.extend
  tagName: "li"
  templateName: 'bottom_tab'
  classNameBindings: ["active"]
  bubbles: false
  click: (event) ->
    @get('controller').send('changeTab', @name)