class UserInterface
  attr_accessor :graph, :timeframe
  def initialize(graph, timeframe, params={})
    @graph, @timeframe = graph, timeframe
    @visitors_page, @loads_pg = params[:visitors_page], params[:loads_pg]
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
  
  class Page < Struct.new(:nr, :current, :uri_hash)
    def current?; current; end
  end
  
  def prev_loads_page_uri_hash
    
  end
  
  def loads_pages
    @graph.loads.nr_pages.times.map do |page_nr|
      Page.new(
        page_nr, 
        (@load_pg == page_nr),
        self.to_uri_hash(loads_pg: page_nr)
      )
    end
  end
  
  def to_uri_hash(overrides)
    ret = { 
      graph: (overrides[:graph] || @graph).to_uri_hash,
      timeframe: (overrides[:timeframe] || @timeframe).to_uri_hash,
      visitors_pg: (overrides[:visitors_pg] || @visitors_pg),
      loads_pg: (overrides[:loads_pg] || @loads_pg)
    }
  end
  
end