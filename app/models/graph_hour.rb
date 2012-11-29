class GraphHour < Graph
  
  def initialize(attr)
    super
    @type = :hour
    attr ||= {}
                             
    @to = attr[:to] || Time.now
    @from = attr[:from] || (@to - 60.minutes)
    
    # from/to not constructed from the date/month/year strings, search how rails does that
    
    puts "attr[:from]: #{attr[:from]}"
    puts "\n@from: #{@from}\n"
    puts "\n@to: #{@to}\n"
  end
  
  def data
    Hash.new(0).tap do |h|
      loads_within_range.each do |load|
        seconds_since_graph_start = load["time"] - from
        i = (seconds_since_graph_start / 60).floor
        h[i] = (h[i] || 0) + 1
      end
    end
  end
  
  # private
  
  def loads_within_range
    loads.find({
      time: { 
        "$gt" => from,
        "$lt" => to,
      }
    }) 
  end
  
end