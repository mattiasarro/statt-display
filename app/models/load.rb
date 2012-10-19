require 'uri'

class Load
  include Mongoid::Document
  
  belongs_to :visitor
  belongs_to :previous, class_name: "Load", inverse_of: :next
  belongs_to :next, class_name: "Load", inverse_of: :previous
  
  field :ip
  field :cl_user_id # optional
  field :cookie_id
  field :time, type: Time
  field :time_on_page, type: Integer # in seconds
  
  field :http_referer
  field :uri_string
  field :query_parameters
  
  attr_accessor :uri
  after_initialize do
    self.uri = URI(uri_string) if uri_string
  end
  delegate :path, :query, :fragment, to: :uri
  
  def time_on_page
    unless (ret = super).nil?
      ret
    else # time since load
      (Time.now - self.time).round
    end
  end
  
  def set_previous
    previous_loads = visitor.loads.desc(:time)
    self.previous = previous_loads.find_by(uri_string: self.http_referer)
    if self.previous
      self.previous.next = self
      self.previous.time_on_page = (self.time - self.previous.time).round
      self.previous.save
    end
  end
end
