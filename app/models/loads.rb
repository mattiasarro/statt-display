class Loads
  PER_PAGE = 30
  
  attr_reader :collection
  def initialize(site, timeframe)
    @site = site
    @timeframe = timeframe
  end
  
  # must be a method (not instance variable) for the
  # with(collection: "site_..._loads") hack to work
  def collection
    @site.loads.desc(:time)
  end
  
  def nr_pages
    (within_range.count / PER_PAGE.to_f).ceil
  end
  
  def page(nr)
    LoadsPage.new(within_range, nr)
  end
  
  def within_range
    collection.where(:time.gt => @timeframe.from, :time.lt => @timeframe.to)
  end
end