class BarsController < ApplicationController
  
  respond_to :json
  
  def index
    respond_with({
      bars: (params[:from] == "1366758000" && params[:to] == "1367189930" ? page1 : page2)
    })
  end
  
  def page1
    logger.debug "-- page 1 --"
    [
      {time: 1367002766, value: 62},
      {time: 1366995567, value: 354},
      {time: 1366988368, value: 292},
      {time: 1366981169, value: 257},
      {time: 1366973970, value: 120},
      {time: 1366966771, value: 157},
      {time: 1366959572, value: 88} ,
      {time: 1366952373, value: 14} ,
      {time: 1366945174, value: 7}  ,
      {time: 1366937975, value: 25} ,
      {time: 1366930776, value: 95} ,
      {time: 1366923577, value: 142},
      {time: 1366916378, value: 95} ,
      {time: 1366909179, value: 121},
      {time: 1366901980, value: 203},
      {time: 1366894781, value: 302},
      {time: 1366887582, value: 392},
      {time: 1366880383, value: 371},
      {time: 1366873184, value: 107},
      {time: 1366865985, value: 18} ,
      {time: 1366858786, value: 11} ,
      {time: 1366851587, value: 24} ,
      {time: 1366844388, value: 42} ,
      {time: 1366837189, value: 156},
      {time: 1366829990, value: 101},
      {time: 1366822791, value: 97} ,
      {time: 1366815592, value: 133},
      {time: 1366808393, value: 95} ,
      {time: 1366801194, value: 225},
      {time: 1366793995, value: 450},
      {time: 1366786796, value: 56} ,
      {time: 1366779597, value: 22} ,
      {time: 1366772398, value: 21} ,
      {time: 1366765199, value: 14} ,
      {time: 1366758000, value: 39}
    ]
  end
  
  def page2
    logger.debug "-- page 2 --"
    [
      {time: 1367002766, value: 0},
      {time: 1366995567, value: 0},
      {time: 1366988368, value: 0},
      {time: 1366981169, value: 0},
      {time: 1366973970, value: 0},
      {time: 1366966771, value: 57},
      {time: 1366959572, value: 8} ,
      {time: 1366952373, value: 4} ,
      {time: 1366945174, value: 12}  ,
      {time: 1366937975, value: 5} ,
      {time: 1366930776, value: 5} ,
      {time: 1366923577, value: 42},
      {time: 1366916378, value: 5} ,
      {time: 1366909179, value: 21},
      {time: 1366901980, value: 3},
      {time: 1366894781, value: 2},
      {time: 1366887582, value: 92},
      {time: 1366880383, value: 71},
      {time: 1366873184, value: 7},
      {time: 1366865985, value: 8} ,
      {time: 1366858786, value: 1} ,
      {time: 1366851587, value: 4} ,
      {time: 1366844388, value: 2} ,
      {time: 1366837189, value: 56},
      {time: 1366829990, value: 1},
      {time: 1366822791, value: 7} ,
      {time: 1366815592, value: 33},
      {time: 1366808393, value: 5} ,
      {time: 1366801194, value: 25},
      {time: 1366793995, value: 50},
      {time: 1366786796, value: 6} ,
      {time: 1366779597, value: 2} ,
      {time: 1366772398, value: 1} ,
      {time: 1366765199, value: 4} ,
      {time: 1366758000, value: 9}
    ]
  end
end