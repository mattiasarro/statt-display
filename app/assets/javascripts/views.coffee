Statt.ApplicationView = Ember.View.extend
  classNames: ["container"]

Statt.LoadView = Ember.View.extend
  templateName: "loads/load"
  tagName: "div"
  classNames: ["load"]
  didInsertElement: (e) ->
    a = this.$()
    a.tooltip()
  click: (event) ->
    console.log($(event.target))
    $(event.target).tooltip("show")