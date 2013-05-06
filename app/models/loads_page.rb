class LoadsPage
  NR_COLUMNS = 3
  
  def initialize(loads, page, nr_pages)
    @skip = nr_pages > 1 ? Loads::PER_PAGE * (nr_pages - page) : 0
    @loads_on_page = loads.within_range.limit(Loads::PER_PAGE).skip(@skip)
  end
  
  def columns_arrays
    return @columns_arrays if @columns_arrays
    load_columns = @loads_on_page.each_slice(col_size)
    @columns_arrays = load_columns.map {|o| o }
  end
  
  def to_json(options={})
    return "[]" if col_size == 0
    {
      earliest_load_time: earliest_load,
      latest_load_time: latest_load,
      loads: columns_arrays
    }.to_json
  end
  
  def earliest_load
    columns_arrays.flatten.last.try(:time).to_i
  end
  
  def latest_load
    columns_arrays.flatten.first.try(:time).to_i
  end
  
  private
  
  def col_size
    @col_size ||= (loads_size / NR_COLUMNS.to_f).ceil
    @col_size == 0 ? 1 : @col_size
  end
  
  # hack, due to loads.size giving ALL loads
  def loads_size
    @loads_size ||= @loads_on_page.map(&:object_id).size
    # @loads_on_page.size
  end
end