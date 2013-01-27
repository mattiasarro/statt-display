class UserInterface
  attr_accessor :graph, :timeframe
  def initialize(graph, timeframe)
    @graph, @timeframe = graph, timeframe
  end
  
  def prev
    @timeframe = @timeframe.clone.prev_page!
    reset_pagination
  end
  
  def next
    @timeframe = @timeframe.clone.next_page!
    reset_pagination
  end
  
  def to_hash(attr)
    from = attr[:from] || @graph.from
    to = attr[:to] || @graph.to
    type = attr[:type] || @graph.type
    nr_bars = attr[:nr_bars] || @graph.nr_bars

    ret = { 
      "type" => type,
      "nr_bars" => nr_bars
    }
    ret.merge!(GraphHelper::pack_time(from, :from))
    ret.merge!(GraphHelper::pack_time(to, :to))
  end
  
  private
  
  def reset_pagination
    
  end
end