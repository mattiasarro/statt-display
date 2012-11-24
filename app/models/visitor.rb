class Visitor
  include Mongoid::Document
  
  belongs_to :site, class_name: "SiteBase"
  has_many :loads
  

  
  # mimicking has_many :loads
  def loads
    site.loads.where(visitor_id: Moped::BSON::ObjectId(self.id)).desc(:time)
  end
  
  field :current_cl_user_id
  field :cl_user_ids, type: Array
    
  def to_s
    if current_cl_user_id.nil? or current_cl_user_id.empty?
      loads.first.try(:ip)
    else
      current_cl_user_id
    end
  end
  
end