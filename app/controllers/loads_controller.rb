class LoadsController < ApplicationController
  
  respond_to :json
  
  def index
    @site = Site.find(params[:site_id])
    @timeframe = Timeframe.new(params[:timeframe])
    @loads = Loads.new(@site, @timeframe)
    @loads_page = @loads.page(params[:page].to_i)
    
    respond_with(@loads_page)
  end

end