class User
  include Mongoid::Document
  
  has_and_belongs_to_many :sites
  
  attr_protected :provider, :uid, :name
  field :provider
  field :uid
  field :name
  field :email
  
  #validates :email, presence: true, email: true
  
  def self.create_with_omniauth(auth)
    create! do |u|
      u.provider = auth["provider"]
      u.uid = auth["uid"]
      if auth["info"]
         u.name = auth["info"]["name"] or ""
         u.email = auth["info"]["email"] or ""
      end
    end
  end
  
  def admin?
    provider == "twitter" && uid == "14820811"
  end
  
  def to_s
    name
  end
end