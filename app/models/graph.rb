class Graph
  attr_accessor :type, :timeframe, :site, :nr_bars, :bar_duration
  delegate :from, :to, :duration, to: :timeframe
  
  DEFAULTS = {
    nr_bars: 60,
    duration: 60.minutes
  }
  
  def initialize(params, timeframe)
    @timeframe = timeframe
    @type = :custom
    @nr_bars = params[:nr_bars] || DEFAULTS[:nr_bars]
    @bar_duration = @timeframe.duration / @nr_bars
  end
  
  def self.options_for_select
    [
      ["60 minutes", :hour],
      ["24 hours", :day],
      ["custom", :custom]
    ]
  end
  
  def data
    @data ||= data_uncached
  end
  
  def data_uncached
    Hash.new(0).tap do |h|
      loads_within_range.each do |load|
        h[calculate_index(load)] += 1
      end
    end
  end
  
  def loads_page(page_nr)
    LoadsPage.new(loads_within_range, page_nr)
  end
  
  def to_uri_hash
    {
      type: @type,
      nr_bars: @nr_bars
    }
  end
  
  protected
  
  # get the timestamp since epoch to the beginning of the bar
  def calculate_index(load)
    seconds_since_graph_start = (load.time - from).to_i
    seconds_inside_bar = (seconds_since_graph_start % @bar_duration).to_i
    time_at_bar_start = load.time.to_i - seconds_inside_bar
  end
  
  def loads
    @site.loads.desc(:time)
  end
  
  def visitors
    @site.visitors
  end
  
  def loads_within_range
    loads.where(:time.gt => from, :time.lt => to)
  end
end