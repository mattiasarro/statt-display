class Load
  include Mongoid::Document
  
  field :ip
  field :user_id
  field :time, type: Time
  
end
