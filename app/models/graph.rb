
class Graph
  include ActiveModel::Conversion
  include ActiveModel::Validations  
  extend ActiveModel::Naming
  
  attr_accessor :type, :from, :to, :site
  
  def self.factory(params)
    params = {type: :hour} unless params
    case params[:type]
    when :hour, nil
      GraphHour.new(params)
    end
  end
  
  def initialize(attr)
    self.to = attr[:to] || Time.now
  end
  
  def persisted?
    false
  end
  
  protected
  
  def loads
    @site.loads.collection
  end
  
  def visitors
    @site.visitors.collection
  end
end