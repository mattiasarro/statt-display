Statt.ApplicationView = Ember.View.extend
  classNames: ["container"]
  didInsertElement: ->
    window.daterange_setup()
    window.graph_rendering_setup()
  

Statt.LoadView = Ember.View.extend
  templateName: "loads/load"
  tagName: "div"
  classNames: ["load"]
  didInsertElement: (e) ->
    load = this._context
    a = this.$().find("a")
    a.tooltip({
      trigger: "manual"
      html: true
      title: () ->
        ret = '<table>'
        ret += '  <tr><td>Title:</td><td>' + load.title + '</td></tr>'
        ret += '  <tr><td>Browser:</td><td>' + load.user_agent + '</td></tr>'
        ret += '  <tr><td>UserID:</td><td>' + load.cl_user_id + '</td></tr>' if load.cl_user_id
        ret += '  <tr><td>On&nbsp;page:</td><td>' + load.top + '</td></tr>'
        ret += '</table>'
    })
  click: (event) ->
    $(event.target).tooltip("toggle")
    