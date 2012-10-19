class Visitor
  include Mongoid::Document
  
  has_many :loads
  
  field :cl_user_id
  field :cookie_ids, type: Array # used only for looking up Visitors
  
  def self.refresh_from_loads(attr = {})
    from, to = attr[:from], (attr[:to] || Time.now)
    loads = Load.where(load_id: nil)
    loads = loads.where(:time.gt => from, :time.lt => to) if (from && to)
    loads.each do |load|
      visitor = find_by_user_or_cookie_id(load.cl_user_id, 
                                          load.cookie_id)
      visitor.track_page_load(load)
    end
  end
  
  # Tries finding a visitor based on cl_user_id, then cookie_id or build the visitor.
  def self.find_by_user_or_cookie_id(cl_user_id, cookie_id)
    if cl_user_id
      visitor = find_by(cl_user_id: cl_user_id)
    else
      visitor = where(:cookie_ids.in => [cookie_id]).first
    end
    visitor || self.new
  end
  
  def track_page_load(load)
    self.add_to_set :cookie_ids, load.cookie_id
    self.loads << load
    self.cl_user_id = load.cl_user_id
    load.set_previous
    self.save && load.save
  end
  
  def to_s
    cl_user_id.try(:empty?) ? loads.last.ip : cl_user_id
  end
  
end