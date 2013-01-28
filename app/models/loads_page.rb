class LoadsPage
  NR_COLUMNS = 3
  
  def initialize(loads, page, nr_pages)
    @skip = Loads::PER_PAGE * (nr_pages - page)
    @loads_on_page = loads.within_range.limit(Loads::PER_PAGE).skip(@skip)
  end
  
  def to_array
    load_columns = @loads_on_page.each_slice(col_size)
    load_columns.map {|o| o }
  end
  
  def to_json
    return "[]" if col_size == 0
    to_array.to_json
  end
  
  private
  
  def col_size
    @col_size ||= (loads_size / NR_COLUMNS.to_f).ceil
  end
  
  # hack, due to loads.size giving ALL loads
  def loads_size
    @loads_size ||= @loads_on_page.map(&:object_id).size
    # @loads_on_page.size
  end
end