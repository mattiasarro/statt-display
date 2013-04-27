# coding: utf-8
require 'uri'

class Load
  include Mongoid::Document
  
  belongs_to :site, class_name: "SiteBase"
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
  
  def color
    md5 = Digest::MD5.hexdigest(self.id)
    md5[0,6]
  end
  
  attr_accessor :uri
  after_initialize do
    us = uri_string.gsub("’", "") # hackety hack
    self.uri = URI(us) if us
  end
  delegate :path, :query, :fragment, to: :uri
  
  def as_json(*a)
    {
      "path" => self.path,
      "time" => self.time,
      "color" => self.color,
      "time_on_page" => self.time_on_page,
      "user_agent" => self.user_agent,
      "title" => self.title,
      
      "uri_string" => self.uri_string,
      "http_referer" => self.http_referer
    }
  end
end
