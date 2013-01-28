class UserInterface
  attr_accessor :graph, :timeframe, :visitors_pg, :loads_pg
  def initialize(params={}, timeframe, graph, loads)
    @graph, @timeframe, @loads = graph, timeframe, loads
    @visitors_pg = params[:visitors_pg] ? params[:visitors_pg].to_i : 1
    @loads_pg = params[:loads_pg] ? params[:loads_pg].to_i : 1
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
  
  def loads_pages
    Pagination.new(
      nr_pages: @loads.nr_pages,
      current: lambda { |pg| @loads_pg == pg },
      uri_base: self.to_uri_hash,
      uri_change: :loads_pg
    )
  end
  
  def to_uri_hash(overrides={})
    { 
      graph: (overrides[:graph] || @graph).to_uri_hash,
      timeframe: (overrides[:timeframe] || @timeframe).to_uri_hash,
      visitors_pg: (overrides[:visitors_pg] || @visitors_pg),
      loads_pg: (overrides[:loads_pg] || @loads_pg)
    }
  end
  
end

class Pagination
  include Enumerable
  
  class Page < Struct.new(:nr, :current, :uri_hash)
    def current?; current; end
  end
  
  def initialize(attr)
    @pages = attr[:nr_pages].times.map do |i|
      pg_nr = i + 1 
      uri_hash = attr[:uri_base].clone
      uri_hash[attr[:uri_change]] = pg_nr
      Page.new(pg_nr, attr[:current].call(pg_nr), uri_hash)
    end
  end
  
  def each(&block)
    @pages.each(&block)
  end
  
  def next
  end
end