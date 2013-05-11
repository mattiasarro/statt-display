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
    # color
    l1 = {path: "/news/2013/04/26/car/1", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l2 = {path: "/news/2013/04/26/car/2", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l3 = {path: "/news/2013/04/26/car/3", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l4 = {path: "/news/2013/04/26/car/4", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l5 = {path: "/news/2013/04/26/car/5", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l6 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l7 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l8 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l9 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l10 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    
    l11 = {path: "/news/2013/04/26/car/1", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l12 = {path: "/news/2013/04/26/car/2", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l13 = {path: "/news/2013/04/26/car/3", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l14 = {path: "/news/2013/04/26/car/4", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l15 = {path: "/news/2013/04/26/car/5", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l16 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l17 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l18 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l19 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l20 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    
    l21 = {path: "/news/2013/04/26/car/1", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l22 = {path: "/news/2013/04/26/car/2", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l23 = {path: "/news/2013/04/26/car/3", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l24 = {path: "/news/2013/04/26/car/4", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l25 = {path: "/news/2013/04/26/car/5", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l26 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l27 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l28 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l29 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l30 = {path: "/news/2013/04/26/car/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    
    respond_with({
      loads: [
        l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,
        l11,l12,l13,l14,l15,l16,l17,l18,l19,l20,
        l21,l22,l23,l24,l25,l26,l27,l28,l29,l30
      ]
    })
  end

end