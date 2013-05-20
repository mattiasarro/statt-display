Statt.ApplicationView = Ember.View.extend
  classNames: ["container"]

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
  

Statt.DaterangeCalendarButton = Ember.View.extend
  tagName: "a"
  classNames: ["btn"]
  attributeBindings: ["id", "data-toggle", "data-original-title"]
  "data-toggle": "button"
  "data-original-title": ""
  id: "daterange-calendar-button"
  click: ->
    chartController = @get("controller")
    
    setup_daterange_selector = ->
      get_graph_date = (from_to) ->
        year = $("#timeframe_#{from_to}_1i").val()
        month = $("#timeframe_#{from_to}_2i").val()
        day = $("#timeframe_#{from_to}_3i").val()
        new Date("#{year}-#{month}-#{day}")
      
      drs = DaterangeSelector({
        selector: "#datepicker", 
        nr_months: 2,
        start_date: () -> (
          # currently need this for start-of-day
          get_graph_date("from")
        ),
        end_date: () -> (
          # currently need this for start-of-day
          get_graph_date("to")
        ),
        start_date_selected: (time) -> (
          @fromTmp = time
        ),
        end_date_selected: (time) -> (
          @toTmp = time
          # go to end of day
          dayInSeconds = (60*60*24) - 1
          @toTmp.setSeconds(@toTmp.getSeconds() + dayInSeconds)
          chartController.send("newTimeframe", @fromTmp, @toTmp)
        )
      })
      
      $("#dp_prev").click ->
        date = $("#datepicker").datepicker("getDate")
        date.setMonth(date.getMonth() - 1)
        $("#datepicker").datepicker("setDate", date)
        drs.initSelected()
      
      $("#dp_next").click ->
        date = $("#datepicker").datepicker("getDate")
        date.setMonth(date.getMonth() + 1)
        $("#datepicker").datepicker("setDate", date)
        drs.initSelected()
      
    
    a = @$()
    poppedOver = a.next('div.popover:visible').length
    if (poppedOver)
      $(".picker-container").html($(".popover-content").html())
      a.popover('hide')
    else
      a.popover('show')
      setup_daterange_selector()
  
  didInsertElement: ->
    a = @$()
    a.popover
      html: true,
      placement: "left",
      trigger: "manual",
      title: false,
      content: ->
        '<div id="picker">
          <div id="datepicker"></div>
          <a id="dp_prev"><i class="icon-chevron-left"></i></a>
          <a id="dp_next"><i class="icon-chevron-right"></i></a>
        </div>'
  
  
Statt.DaterangeSelectButton = Ember.View.extend
  tagName: "a"
  classNames: ["btn"]
  attributeBindings: ["id", "data-toggle", "data-original-title"]
  "data-toggle": "button"
  "data-original-title": ""
  id: "daterange-select-button"
  click: (event) ->
    a = @$()
    poppedOver = a.next('div.popover:visible').length
    if (poppedOver)
      $("#daterange-select-container").html($(".popover-content").html())
      a.popover('hide')
    else
      a.popover('show')
  
  didInsertElement: ->
    a = @$()
    a.popover
      html: true
      placement: "left"
      trigger: "manual"
      title: false
      content: ->
        $('#daterange-select-dropdowns').show()
        $('#daterange-select-container').html()
  
  
  update_rails_datetime_select: (id, time, start_end) ->
    trailing_zero = (num) ->
      if (num < 9) then ("0" + (num + 1).toString()) else (num + 1)
    
    $(id + "_3i}").val(time.getDate())
    $(id + "_2i}").val(trailing_zero(time.getMonth()))
    $(id + "_1i}").val(1900 + time.getYear())
    
    if (start_end == "start")
      $(id + "_4i").val("00")
      $(id + "_5i").val("00")
    else
      $(id + "_4i").val("23")
      $(id + "_5i").val("59")
  

Statt.TimeframeForm = Ember.View.extend
  tagName: "form"
  getDate: (year, month, day, hour, minute) ->
    year = parseInt(year)
    month = parseInt(month) - 1
    day = parseInt(day)
    hour = parseInt(hour)
    minute = parseInt(minute)
    new Date(year,month,day,hour,minute)
  
  submit: (event) ->
    newValueOf = (selector) ->
      $(event.currentTarget).find(selector).val()
    
    from = @getDate(
      newValueOf("#timeframe_from_1i")
      newValueOf("#timeframe_from_2i")
      newValueOf("#timeframe_from_3i")
      newValueOf("#timeframe_from_4i")
      newValueOf("#timeframe_from_5i")
    )
    to = @getDate(
      newValueOf("#timeframe_to_1i")
      newValueOf("#timeframe_to_2i")
      newValueOf("#timeframe_to_3i")
      newValueOf("#timeframe_to_4i")
      newValueOf("#timeframe_to_5i")
    )
    chartController = @get("controller.controllers.chart")
    chartController.send("newTimeframe", from, to)
    false

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
        ret += '  <tr><td>Title:</td><td>' + load.get("title") + '</td></tr>'
        ret += '  <tr><td>Browser:</td><td>' + load.get("userAgent") + '</td></tr>'
        ret += '  <tr><td>UserID:</td><td>' + load.get("clUserId") + '</td></tr>' if load.get("clUserId")
        ret += '  <tr><td>On&nbsp;page:</td><td>' + load.get("timeOnPageStr") + '</td></tr>'
        ret += '</table>'
    })
  
  click: (event) ->
    $(event.target).tooltip("toggle")
  
