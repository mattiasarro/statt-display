class Graph
  # Imitate ActiveRecord object to be able to have form_for
  include ActiveModel::Conversion
  include ActiveModel::Validations  
  extend ActiveModel::Naming
  def persisted?; false; end
  
  attr_accessor :type, :from, :to, :site, :nr_bars
  
  def self.factory(params)
    if params[:graph_hour]
      GraphHour.new(params[:graph_hour])
    end
  end
  
  def initialize(params)
    parse_time params, :from
    parse_time params, :to
  end
  
  def data
    @data ||= Hash.new(0).tap do |h|
      loads_within_range.each do |load|
        h[calculate_index(load)] += 1
      end
    end
  end
  
  protected
  
  def calculate_index(load)
    seconds_since_graph_start = load["time"] - from
    (seconds_since_graph_start / @bar_duration).floor
  end
  
  def loads
    @site.loads.collection
  end
  
  def visitors
    @site.visitors.collection
  end
  
  def loads_within_range
    loads.find({
      time: { 
        "$gt" => from,
        "$lt" => to,
      }
    }) 
  end
    
  def parse_time(params, sym)
    return unless params["#{sym}(1i)"]
    t = Time.new(
      params["#{sym}(1i)"].to_i, 
      params["#{sym}(2i)"].to_i,
      params["#{sym}(3i)"].to_i,
      params["#{sym}(4i)"].to_i,
      params["#{sym}(5i)"].to_i
    )
    send "#{sym}=", t
  end

end