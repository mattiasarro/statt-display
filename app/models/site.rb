class Site
  include Mongoid::Document
  
  has_and_belongs_to_many :users
  embeds_many :visitors
  embeds_many :loads
  
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