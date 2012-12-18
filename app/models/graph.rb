class Graph
  attr_accessor :type, :from, :to, :site, :nr_bars, :bar_duration
  
  def self.factory(params)
    case (params && params[:graph] && params[:graph][:type]) ? params[:graph][:type] : nil
    when "hour" then GraphHour.new(params[:graph])
    when "day" then GraphDay.new(params[:graph])
    else GraphHour.new(params[:graph])
    end
  end
  
  def self.options_for_select
    [
      ["60 minutes", :hour],
      ["24 hours", :day]
    ]
  end
  
  def initialize(params)
    if params
      parse_time params, :from
      parse_time params, :to
    end
  end
  
  def data
    @data ||= Hash.new(0).tap do |h|
      loads_within_range.each do |load|
        h[calculate_index(load)] += 1
      end
    end
  end
  
  def query_params(sym)
    if sym == :prev
      @new_from_time = @from - @graph_duration
    elsif sym == :next
      @new_from_time = @from + @graph_duration
    end
    {
          "type" => @type,
      "from(1i)" => @new_from_time.year,
      "from(2i)" => @new_from_time.month,
      "from(3i)" => @new_from_time.day,
      "from(4i)" => @new_from_time.hour,
      "from(5i)" => @new_from_time.min,
      "from(6i)" => @new_from_time.sec
    }
  end
  
  protected
  
  # get the timestamp since epoch to the beginning of the bar
  def calculate_index(load)
    seconds_since_graph_start = (load["time"] - from).to_i
    seconds_inside_bar = (seconds_since_graph_start % @bar_duration).to_i
    time_at_bar_start = load["time"].to_i - seconds_inside_bar
  end
  
  def loads
    @site.loads.collection
  end
  
  def visitors
    @site.visitors.collection
  end
  
  def loads_within_range
    loads.find({
      time: { 
        "$gt" => from,
        "$lt" => to,
      }
    }) 
  end
  
  def init_from_to(params)
    if @from
      @to = @from + @graph_duration
    else
      @to = Time.now
      @from = @to - @graph_duration
    end
  end
  
  def parse_time(params, sym)
    return unless params["#{sym}(1i)"]
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