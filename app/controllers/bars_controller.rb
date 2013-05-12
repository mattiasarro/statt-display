class BarsController < ApplicationController
  
  respond_to :json
  
  def index
    from = Time.at(params[:from].to_i)
    to = Time.at(params[:to].to_i)
    params[:id] = params[:site_id]
    
    @site = Site.find(params[:id])
    @timeframe = Timeframe.new(from: from, to: to)
    @loads = Loads.new(@site, @timeframe)
    @graph = Graph.new(@loads, params[:nr_bars].to_i)
    @graph.site = @site # not needed after visitors() refactored
    
    data = []
    @graph.data.each do |k,v|
      data.push({time: k, value: v})
    end
        
    respond_with({
      bars: data
    })
  end
  
end