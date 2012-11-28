class GraphHour < Graph
  
  def initialize(attr)
    attr ||= {}
    super
    self.type = :hour
  end
  
  def from
    to - 60.minutes
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
  
  private
  
  def loads_within_range
    loads.find({
      time: { 
        "$gt" => from,
        "$lt" => to,
      }
    }) 
  end
  
end