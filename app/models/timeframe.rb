class Timeframe
  attr_accessor :from, :to, :duration
  def initialize(attr={})
    attr = {} if attr.nil?
    @from = parse_time(attr, :from)
    @to   = parse_time(attr, :to)
    @duration = attr[:duration] || Graph::DEFAULTS[:duration]
    
    if @from && (not @to)
      @to = @from + @duration
    elsif (not @from)
      @to = Time.now
      @from = @to - @duration
    end
  end
  
  def prev_page!
    @to = @from
    @from -= @duration
  end
  
  def next_page!
    @from = @to
    @to += @duration
  end
  
  private
  
  def parse_time(params, sym)
    return unless params and params["#{sym}(1i)"]
    Time.new(
      params["#{sym}(1i)"].to_i, 
      params["#{sym}(2i)"].to_i,
      params["#{sym}(3i)"].to_i,
      params["#{sym}(4i)"].to_i,
      params["#{sym}(5i)"].to_i
    )
  end
  
end