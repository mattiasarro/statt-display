DEBUG = true

Statt.LoadsIndexController = Ember.ArrayController.extend
  something: 1

Statt.ChartController = Ember.ObjectController.extend
  width: 938 # including padding
  height: 193 # including padding
  padding: 10
  transform: (->
    "translate(" + @padding + ", " + @padding + ")"
  ).property()

Statt.BarsController = Ember.ArrayController.extend
  something: 1