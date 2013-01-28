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
      current_pg: @loads_pg,
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
    def disabled?; false; end
  end
  
  class PageDisabled
    def disabled?; true; end
    def uri_hash; {}; end
  end
  
  attr_reader :windows
  def initialize(attr)
    @nr_pages, @current_pg = attr[:nr_pages], attr[:current_pg]
    @uri_base, @uri_change = attr[:uri_base], attr[:uri_change]
    @pages = @nr_pages.times.map do |i| 
      new_page(i + 1).tap do |page|
        @current_pg_index = i if page.current?
      end
    end
  end
  
  def each(&block)
    @pages.each(&block)
  end
  
  def windowed?
    (@pages.size > 11) && 
    (6..(@nr_pages-6)).include?(@current_pg_index)
  end
  
  def windows
    @windows ||= [
      @pages[0..2],
      @pages[(@current_pg_index-2)..(@current_pg_index+2)],
      (@current_pg_index == (@pages.size-7) ? @pages[-4..-1] : @pages[-3..-1])
    ]
  end
  
  def prev
    if @current_pg == 1
      PageDisabled.new
    else
      new_page(@current_pg - 1)
    end
  end
  
  def next
    if @current_pg == @nr_pages
      PageDisabled.new
    else
      new_page(@current_pg + 1)
    end
  end
  
  private
  
  def new_page(pg_nr)
    uri_hash = @uri_base.clone
    uri_hash[@uri_change] = pg_nr
    Page.new(pg_nr, (@current_pg == pg_nr), uri_hash)
  end
end