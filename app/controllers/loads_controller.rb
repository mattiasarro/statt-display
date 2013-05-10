class LoadsController < ApplicationController
  
  respond_to :json
  
  def index_old
    @site = Site.find(params[:site_id])
    @timeframe = Timeframe.new(params[:timeframe])
    @loads = Loads.new(@site, @timeframe)
    @loads_page = @loads.page(params[:loads_pg_nr].to_i)
    
    respond_with(@loads_page)
  end
  
  def index
    respond_with({loads_pages: [{page_nr: 8, nr_pages: 15}]})
  end

end