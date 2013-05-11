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
    l1 = {path: "/news/2013/04/26/car/1", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l2 = {path: "/news/2013/04/26/car/2", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l3 = {path: "/news/2013/04/26/car/3", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l4 = {path: "/news/2013/04/26/car/4", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l5 = {path: "/news/2013/04/26/car/5", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l6 = {path: "/news/2013/04/26/car/6", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    respond_with({
      loads: [l1,l2,l3,l4,l5,l6]
#      , pages: {{id: 1, nr: 1},{id: 2, nr: 2}}
    })
  end

end