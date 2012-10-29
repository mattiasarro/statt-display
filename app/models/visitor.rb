class Visitor
  include Mongoid::Document
  
  embedded_in :site
  
  # mimicking has_many :loads
  def loads
    site.loads.where(visitor: self)
  end
  
  field :cl_user_id
  field :cookie_ids, type: Array # used only for looking up Visitors
  
  # Tries finding a visitor based on cl_user_id, then cookie_id or build the visitor.
  def self.find_by_user_or_cookie_id(cl_user_id, cookie_id)
    if cl_user_id
      find_by(cl_user_id: cl_user_id)
    else
      where(:cookie_ids.in => [cookie_id]).first
    end
  end
  
  def track_page_load(load)
    self.add_to_set :cookie_ids, load.cookie_id
    self.cl_user_id = load.cl_user_id
    load.visitor = self
    load.set_previous
    self.save && load.save
  end
  
  def to_s
    cl_user_id.try(:empty?) ? loads.last.ip : cl_user_id
  end
  
end