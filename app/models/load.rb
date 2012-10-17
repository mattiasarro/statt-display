class Load
  include Mongoid::Document
  
  belongs_to :visitor
  
  field :ip
  field :cl_user_id # optional
  field :cookie_id
  field :http_referrer
  field :time, type: Time
  
end
