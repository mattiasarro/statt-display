class UserInterface
  attr_accessor :graph, :timeframe, :visitors_pg, :loads_pagination
  def initialize(params={}, timeframe, graph, loads)
    @graph, @timeframe, @loads = graph, timeframe, loads
    @visitors_pg = params[:visitors_pg] ? params[:visitors_pg].to_i : 1
    @site_id = params[:id]
    
    @loads_pagination = PaginationLoads.new(
      nr_pages: @loads.nr_pages,
      current_pg: (params[:loads_pg] ? params[:loads_pg].to_i : @loads.nr_pages),
      uri_base: self.to_uri_hash
    )
  end
  
  def prev_uri_hash
    self.to_uri_hash(
      timeframe: @timeframe.clone.prev_page!,
      tab: "loads",
      loads_pg: 1
    )
  end
  
  def next_uri_hash
    self.to_uri_hash(
      timeframe: @timeframe.clone.next_page!,
      tab: "loads",
      loads_pg: 1
    )
  end
  
  def to_uri_hash(overrides={})
    { 
      site_id: @site_id,
      graph: (overrides[:graph] || @graph).to_uri_hash,
      timeframe: (overrides[:timeframe] || @timeframe).to_uri_hash,
      visitors_pg: (overrides[:visitors_pg] || @visitors_pg),
      loads_pg: (overrides[:loads_pg] || @loads_pg)
    }
  end
  
  def to_json
    ret = to_uri_hash
    ret["loads_pagination"] = @loads_pagination.ui_state
    ret.to_json
  end
  
end