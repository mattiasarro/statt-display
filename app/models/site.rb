class Site
  include Mongoid::Document
  
  has_and_belongs_to_many :users
  
  has_many :visitorz, class_name: "Visitor", inverse_of: :site
  has_many :loadz, class_name: "Load", inverse_of: :site
    
  def visitors
    visitorz.with(collection: "site_#{id}_visitors")
  end
  
  def loads
    loadz.with(collection: "site_#{id}_loads")
  end
  
  field :name
  embeds_many :domains
  accepts_nested_attributes_for :domains, allow_destroy: true
  
end

class Domain
  include Mongoid::Document
  embedded_in :site
  field :name
  
  def to_s
    name
  end
end