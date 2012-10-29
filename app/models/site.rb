class Site
  include Mongoid::Document
  
  has_and_belongs_to_many :users
  embeds_many :visitors
  embeds_many :loads
  
  field :name
  embeds_many :domains
  accepts_nested_attributes_for :domains, allow_destroy: true
  
  def refresh_visitors(attr = {})
    from, to = attr[:from], (attr[:to] || Time.now)
    loadz = loads.where(load_id: nil).asc(:time) # asc(:time) needed, visitor.loads later uses this to find the previous load 
    loadz = loadz.where(:time.gt => from, :time.lt => to) if (from && to)
    loadz.each do |load|
      visitor = visitors.find_by_user_or_cookie_id(load.cl_user_id, 
                                                   load.cookie_id)
      visitor = visitors.build unless visitor
      visitor.track_page_load(load)
    end
  end
end

class Domain
  include Mongoid::Document
  embedded_in :site
  field :name
  
  def to_s
    name
  end
end