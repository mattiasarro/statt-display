class Loads
  PER_PAGE = 30
  
  attr_accessor :timeframe
  def initialize(site, timeframe)
    @site = site
    @timeframe = timeframe
  end
  
  def nr_pages
    @nr_pages ||= (within_range.count / PER_PAGE.to_f).ceil
  end
  
  def page(nr)
    LoadsPage.new(self, nr, nr_pages)
  end
  
  # regenerate this Criteria every time
  def within_range
    @site.loads.desc(:time).where(:time.gt => @timeframe.from, :time.lt => @timeframe.to)
  end
end