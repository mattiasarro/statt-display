class Graph
  attr_accessor :type, :from, :to, :site, :nr_bars, :bar_duration, :graph_duration
  
  def self.factory(params)
    case (params && params[:graph] && params[:graph][:type]) ? params[:graph][:type] : nil
    when "hour" then GraphHour.new(params[:graph])
    when "day" then GraphDay.new(params[:graph])
    when "custom" then GraphCustom.new(params[:graph])
    else GraphHour.new(params[:graph])
    end
  end
  
  def self.options_for_select
    [
      ["60 minutes", :hour],
      ["24 hours", :day],
      ["custom", :custom]
    ]
  end
  
  def initialize(params)
    parse_time params, :from
    parse_time params, :to
  end
  
  def data
    @data ||= data_uncached # separate _uncached function for testing purposes
  end
  
  def data_uncached
    Hash.new(0).tap do |h|
      loads_within_range.each do |load|
        h[calculate_index(load)] += 1
      end
    end
  end
  
  
  protected
  
  # get the timestamp since epoch to the beginning of the bar
  def calculate_index(load)
    seconds_since_graph_start = (load.time - from).to_i
    seconds_inside_bar = (seconds_since_graph_start % @bar_duration).to_i
    time_at_bar_start = load.time.to_i - seconds_inside_bar
  end
  
  def loads
    @site.loads
  end
  
  def visitors
    @site.visitors
  end
  
  def loads_within_range
    loads.where(:time.gt => from, :time.lt => to)
  end
  
  def init_from_to(params)
    if @from
      @to = @from + @graph_duration
    else
      @to = Time.now
      @from = @to - @graph_duration
    end
  end
  
  # todo: move to helper, call from controller?
  def parse_time(params, sym)
    return unless params and params["#{sym}(1i)"]
    t = Time.new(
      params["#{sym}(1i)"].to_i, 
      params["#{sym}(2i)"].to_i,
      params["#{sym}(3i)"].to_i,
      params["#{sym}(4i)"].to_i,
      params["#{sym}(5i)"].to_i
    )
    send "#{sym}=", t
  end

end