class User
  include Mongoid::Document
  
  attr_protected :provider, :uid, :name
  
  field :provider
  field :uid
  field :name
  field :email
  
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
