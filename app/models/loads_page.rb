class LoadsPage
  NR_COLUMNS = 3
  
  def initialize(loads_within_range, page)
    offset = Loads::PER_PAGE * (page - 1)
    @loads_within_range = loads_within_range.limit(Loads::PER_PAGE).skip(offset)
  end
  
  def to_array
    load_columns = @loads_within_range.each_slice(col_size)
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
    @loads_within_range.map(&:object_id).size
  end
end