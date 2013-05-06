class Pagination
  include Enumerable
  include Rails.application.routes.url_helpers
  
  class Page < Struct.new(:nr, :current, :uri_hash, :ajax_uri)
    def current?; current; end
    def disabled?; false; end
    
    def to_json
      {nr: @nr, name: @nr}
    end
  end
  
  class PageDisabled
    def disabled?; true; end
    def uri_hash; {}; end
  end
  
  attr_reader :windows, :nr_pages, :current_pg
  def initialize(attr)
    @nr_pages, @current_pg = attr[:nr_pages], attr[:current_pg]
    @uri_base = attr[:uri_base]
    @pages = @nr_pages.times.map do |i| 
      new_page(i + 1).tap do |page| # new_page defined in Pagination* subclass
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
  
  Window = Struct.new(:pages, :separator)
  
  def windows
    return @windows if @windows
    @windows = []
    @negative_index = -(@nr_pages - @current_pg_index - 1)
    
    if @nr_pages <= 13
      @windows << Window.new(@pages, false)
    elsif (0..5).include? @current_pg_index
      @windows << Window.new(@pages[0..7],  false)
      @windows << Window.new(@pages[-3..-1], true)
    elsif (-5..0).include? @negative_index
      @windows << Window.new(@pages[0..2], false)
      @windows << Window.new(@pages[-8..-1], true)
    else
      @windows << Window.new(@pages[0..2], false)
      @windows << Window.new(@pages[(@current_pg_index-2)..(@current_pg_index+2)], true)
      @windows << Window.new(@pages[-3..-1], true)
    end
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
  
  def ui_state
    {current_pg: @current_pg, nr_pages: @nr_pages}
  end
  
end