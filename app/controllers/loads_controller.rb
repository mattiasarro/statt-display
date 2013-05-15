class LoadsController < ApplicationController
  
  respond_to :json
  
  def index
    from = Time.at(params[:from].to_i)
    to = Time.at(params[:to].to_i)
    params[:id] = params[:site_id]
    
    @site = Site.find(params[:id])
    @timeframe = Timeframe.new(from: from, to: to)
    @loads = Loads.new(@site, @timeframe)
    @loads_page = @loads.page(params[:loads_pg_nr].to_i)
    
    respond_with({loads: @loads_page.loads_on_page.reverse})
  end
  
end