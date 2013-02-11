class PaginationLoads < Pagination
  def new_page(pg_nr)
    current = (@current_pg == pg_nr)
    uri_hash = @uri_base.clone
    uri_hash[:loads_pg] = pg_nr    
    ajax_uri = site_loads_path(@uri_base[:site_id], timeframe: @uri_base[:timeframe], page: pg_nr)
    Page.new(pg_nr, current, uri_hash, ajax_uri)
  end
end