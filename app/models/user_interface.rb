class UserInterface
  attr_accessor :graph, :timeframe
  def initialize(graph, timeframe)
    @graph, @timeframe = graph, timeframe
  end
  
  def prev_uri_hash
    self.to_uri_hash(
      timeframe: @timeframe.clone.prev_page!,
      tab: "loads",
      loads_page: 1
    )
  end
  
  def next_uri_hash
    self.to_uri_hash(
      timeframe: @timeframe.clone.next_page!,
      tab: "loads",
      loads_page: 1
    )
  end
  
  def to_uri_hash(overrides)
    graph = overrides[:graph] || @graph
    timeframe = overrides[:timeframe] || @timeframe
    
    ret = { 
      graph: graph.to_uri_hash,
      timeframe: timeframe.to_uri_hash
    }
  end
  
end