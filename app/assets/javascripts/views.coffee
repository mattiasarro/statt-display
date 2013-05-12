Statt.ApplicationView = Ember.View.extend
  classNames: ["container"]
  didInsertElement: ->
    window.daterange_setup()

Statt.ChartView = Ember.View.extend
  didInsertElement: -> 
    @defineBottomAxis()
    @defineBars()
  defineBottomAxis: ->
    from_time = new Date(@get("controller.content.from") * 1000)
    to_time   = new Date(@get("controller.content.to") * 1000)
    chart_width = @get("controller").width
    
    xScale = d3.time.scale()
    .domain([from_time, to_time])
    .range([10, chart_width])
    
    xAxis = d3.svg.axis()
    .scale(xScale)
    .orient("bottom")
    
    axis = d3.select("div#chart_container svg.axis")
    .append("g")
    .attr("class", "axis")
    .call(xAxis)
  
  defineBars: ->
    controller = @get("controller")
    chartModel = controller.get("content")
    renderBars = (data) ->
      x = controller.get("xScale")
      y = controller.get("yScale")
      from = controller.get("content.from")
      chart_height = controller.get("height")
      bar_width = controller.get("barWidth")
      
      key_function = (d) -> 
        (typeof d == undefined ? 0 : d.get("time"))
      
      bar_x = (d,i) -> 
        (x(d.get("time") - from) - .5)
      
      bar_y = (d) -> 
        if typeof d == undefined
          0
        else 
          chart_height - y(d.get("value")) - 1
      
      bar_height = (d) ->
        if typeof d == undefined
          0
        else
          y(d.get("value"))
      
      
      chart = d3.select("div#chart_container svg.chart")
      bars = () ->
        bars = chart.selectAll("rect.bar")
        .data(data, key_function)

        bars.enter().insert("rect")
        .attr("class", "bar")

        # .attr("x", (d,i) -> (x(i+1) - .5)) # entering bars all shifted to the right
        .attr("x", bar_x)
        .attr("y", bar_y)
        .attr("width", bar_width)
        .attr("height", bar_height)
        .transition() # fade the entering bar in
        .duration(1000)
        .attr("x", bar_x) # shift it to current position

        # shift all bars to the left
        bars.transition()
        .duration(1000)
        .attr("x", bar_x)

        bars.exit().transition()
        .duration(1000)
        .attr("x", (d,i) -> (x(i-1) - .5)) # one bar outside of view (left)
        .remove()
      
      bars()
      
      labels = () ->
        labels = chart.selectAll("text.label")
        .data(data).enter().append("text")
          .text((d) -> d.get("value"))
          .attr("class", "label")
          .attr("x", (d,i) -> (bar_x(d,i) + 2))
          .attr("y", (d) -> (bar_y(d) + 10))
      
      labels()
      
    if chartModel.isLoaded
      d = chartModel.toArray()
      renderBars(d)
    else
      chartModel.on "didLoad", (o) ->
        d = @get("content").map((i) -> i.record)
        renderBars(d)
  

Statt.LoadView = Ember.View.extend
  templateName: "loads/load"
  tagName: "div"
  classNames: ["load"]
  #didInsertElement: (e) ->
  #  load = this._context
  #  a = this.$().find("a")
  #  a.tooltip({
  #    trigger: "manual"
  #    html: true
  #    title: () ->
  #      ret = '<table>'
  #      ret += '  <tr><td>Title:</td><td>' + load.title + '</td></tr>'
  #      ret += '  <tr><td>Browser:</td><td>' + load.user_agent + '</td></tr>'
  #      ret += '  <tr><td>UserID:</td><td>' + load.cl_user_id + '</td></tr>' if load.cl_user_id
  #      ret += '  <tr><td>On&nbsp;page:</td><td>' + load.top + '</td></tr>'
  #      ret += '</table>'
  #  })
  #click: (event) ->
  #  $(event.target).tooltip("toggle")
    