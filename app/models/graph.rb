class Graph
  attr_accessor :type, :timeframe, :site, :nr_bars, :bar_duration
  delegate :from, :to, :duration, to: :timeframe
  
  DEFAULTS = {
    nr_bars: 60,
    duration: 60.minutes
  }
  
  def initialize(loads, nr_bars)
    @loads, @timeframe = loads, loads.timeframe
    @nr_bars = nr_bars || DEFAULTS[:nr_bars]
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
      @loads.within_range.each do |load|
        h[calculate_index(load)] += 1
      end
    end
  end
  
  def to_uri_hash
    { nr_bars: @nr_bars }
  end
  
  protected
  
  # get the timestamp since epoch to the beginning of the bar
  def calculate_index(load)
    seconds_since_graph_start = load.time.to_i - from.to_i
    seconds_inside_bar = seconds_since_graph_start % @bar_duration
    time_at_bar_start = load.time.to_i - seconds_inside_bar
  end
  
  def visitors
    @site.visitors
  end
  
end