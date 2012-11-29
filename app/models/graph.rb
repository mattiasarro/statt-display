class Graph
  include ActiveModel::Conversion
  include ActiveModel::Validations  
  extend ActiveModel::Naming
  
  attr_accessor :type, :from, :to, :site
  
  def self.factory(params)
    if params[:graph_hour]
      GraphHour.new(params[:graph_hour])
    end
  end
  
  def initialize(params)
    parse_time params, :from
    parse_time params, :to
  end
  
  def persisted?
    false
  end
  
  # protected
  
  def loads
    @site.loads.collection
  end
  
  def visitors
    @site.visitors.collection
  end
  
  def parse_time(params, sym)
    return unless params["#{sym}(1i)"]
    params[sym] = Time.new(
      params["#{sym}(1i)"].to_i, 
      params["#{sym}(2i)"].to_i,
      params["#{sym}(3i)"].to_i,
      params["#{sym}(4i)"].to_i,
      params["#{sym}(5i)"].to_i
    )
  end
end