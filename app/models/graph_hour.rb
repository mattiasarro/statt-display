class GraphHour < Graph
  
  def initialize(params)
    super
    
    @type = :hour
    @graph_duration = 60.minutes # 60 * 60
    @nr_bars = 60
    @bar_duration = @graph_duration / @nr_bars # 1 minute
    
    init_from_to(params)
  end
  
  def init_from_to(params)
    if @from
      @to = @from + @graph_duration
    else
      @to = Time.now
      @from = @to - @graph_duration
    end
  end
  
end