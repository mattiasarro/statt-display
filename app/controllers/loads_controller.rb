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
    l = {path: "/news/2013/04/26/car/", user_agent: "Mozilla/5.0"}
    respond_with({
      loads: [l,l,l,l,l,l]
#      , pages: {{id: 1, nr: 1},{id: 2, nr: 2}}
    })
  end

end