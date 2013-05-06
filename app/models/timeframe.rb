class Timeframe
  attr_accessor :from, :to, :duration
  def initialize(attr={})
    attr = {} if attr.nil?
    @from = parse_time(attr, :from)
    @to   = parse_time(attr, :to)
    
    
    if @from && @to
      @duration = @to - @from
    else
      @duration = attr[:duration] ? attr[:duration].to_i : Graph::DEFAULTS[:duration]
    end

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
    self
  end
  
  def next_page!
    @from = @to
    @to += @duration
    self
  end
  
  def to_uri_hash
    ret = { duration: @duration.to_i }
    ret.merge!(pack_time(@from, :from))
    ret.merge!(pack_time(@to, :to))
  end
  
  private
  
  def pack_time(time, sym)
    {
      "#{sym}(1i)" => time.year,
      "#{sym}(2i)" => time.month,
      "#{sym}(3i)" => time.day,
      "#{sym}(4i)" => time.hour,
      "#{sym}(5i)" => time.min,
      "#{sym}(6i)" => time.sec
    }
  end
  
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