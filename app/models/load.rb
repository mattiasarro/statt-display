require 'uri'

class Load
  include Mongoid::Document
  
  belongs_to :site, inverse_of: :loadz
  belongs_to :visitor
  
  # build a Criteria manually!
  belongs_to :previous, class_name: "Load" # this is buggy due to our funky collection
  belongs_to :next, class_name: "Load" # this is buggy due to our funky collection
  def previous
    return nil unless previous_id
    site.loads.find(Moped::BSON::ObjectId(previous_id))
  end
  def next
    return nil unless next_id
    site.loads.find(Moped::BSON::ObjectId(next_id))
  end
  
  
  field :uri_string
  field :http_referer
  field :title
  field :user_agent
  
  field :screenx
  field :browserx
  field :browsery
  
  field :ip
  field :cl_user_id # optional
  field :query_parameters
  
  field :time, type: Time
  field :time_on_page, type: Integer # in seconds
  
  attr_accessor :uri
  after_initialize do
    self.uri = URI(uri_string) if uri_string
  end
  delegate :path, :query, :fragment, to: :uri
  
end
