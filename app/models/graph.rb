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



class LoadsPage
  PER_PAGE = 30
  NR_COLUMNS = 3
  
  def initialize(loads, page)
    offset = PER_PAGE * (page - 1)
    @loads = loads.limit(PER_PAGE).skip(offset)
  end
  
  def to_json
    return "[]" if col_size == 0
    load_columns = @loads.each_slice(col_size)
    load_columns.map {|o| o }.to_json
  end
  
  private
  
  def col_size
    (loads_size / NR_COLUMNS.to_f).ceil
  end
  
  # hack, due to loads.size giving ALL loads
  def loads_size
    @loads.map(&:object_id).size
  end
end