class GraphDay < Graph
  
  def initialize(params)
    super
    
    @type = :day
    @graph_duration = 1.day # 24 * 60 * 60
    @nr_bars = 24
    @bar_duration = @graph_duration / @nr_bars # 1 hour
    
    init_from_to(params) # inherited, no need to overwrite
  end
  
end