class Load
  include Mongoid::Document
  
  belongs_to :visitor
  
  field :ip
  field :cl_user_id # optional
  field :cookie_id
  field :time, type: Time
  
  field :http_referrer
  field :path
  field :query_parameters
end
