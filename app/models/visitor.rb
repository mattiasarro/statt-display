class Visitor
  include Mongoid::Document
  
  embedded_in :site
  
  # mimicking has_many :loads
  def loads
    site.loads.desc(:time).where(visitor_id: self.id)
  end
  
  field :current_cl_user_id
  field :cl_user_ids, type: Array
    
  def to_s
    if current_cl_user_id.nil? or current_cl_user_id.empty?
      loads.first.ip
    else
      current_cl_user_id
    end
  end
  
end