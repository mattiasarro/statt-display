zero_pad = (x) ->
  if x < 10 then '0'+x else ''+x

Date::full = ->
  d = zero_pad(this.getDate())
  m = zero_pad(this.getMonth() + 1)
  y = this.getFullYear()
  hh = zero_pad(this.getHours())
  mm = zero_pad(this.getMinutes())
  y + "." + m + "." + d + " " + hh + ":" + mm

Date::time = ->
  hh = zero_pad(this.getHours())
  mm = zero_pad(this.getMinutes())
  hh + ":" + mm