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
    respond_with({
      loads: (params[:loads_pg_nr].to_i == 1 ? page1 : page2)
    })
  end
  
  def page1
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
    
    [
      l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,
      l11,l12,l13,l14,l15,l16,l17,l18,l19,l20,
      l21,l22,l23,l24,l25,l26,l27,l28,l29,l30
    ]
  end
  
  def page2
    l1 = {path: "/page2/1", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l2 = {path: "/page2/2", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l3 = {path: "/page2/3", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l4 = {path: "/page2/4", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l5 = {path: "/page2/5", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l6 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l7 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l8 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l9 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l10 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    
    l11 = {path: "/page2/1", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l12 = {path: "/page2/2", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l13 = {path: "/page2/3", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l14 = {path: "/page2/4", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l15 = {path: "/page2/5", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l16 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l17 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l18 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l19 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l20 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    
    l21 = {path: "/page2/1", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l22 = {path: "/page2/2", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l23 = {path: "/page2/3", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l24 = {path: "/page2/4", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l25 = {path: "/page2/5", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l26 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l27 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l28 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l29 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    l30 = {path: "/page2/6", color: "123456", user_agent: "Mozilla/5.0", time: Time.now.to_i}
    
    [
      l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,
      l11,l12,l13,l14,l15,l16,l17,l18,l19,l20,
      l21,l22,l23,l24,l25,l26,l27,l28,l29,l30
    ]
  end

end