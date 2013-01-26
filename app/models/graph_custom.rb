class GraphCustom < Graph
  
  def initialize(params)
    super
    
    @type = :custom
    @graph_duration = @to - @from
    @nr_bars = params["nr_bars"].to_i
    @bar_duration = @graph_duration / @nr_bars
    
    init_from_to
  end
  
end