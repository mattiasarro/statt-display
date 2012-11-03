require 'uri'

class Load
  include Mongoid::Document
  
  embedded_in :site
  belongs_to :visitor # comment this out because visitors are embedded under Site as well; let's see how many times we need to use this relation anyway
  belongs_to :previous, class_name: "Load", inverse_of: :next
  belongs_to :next, class_name: "Load", inverse_of: :previous
  
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
  
  def visitor
    return @visitor if @visitor
    @visitor = site.visitors.find(visitor_id)
  end
  
  after_create :set_previous_and_time_on_page
  after_create :set_cl_user_ids
  
  def set_cl_user_ids
    if self.cl_user_id
      visitor.add_to_set :cl_user_ids, self.cl_user_id
      visitor.current_cl_user_id = self.cl_user_id
      visitor.save
    end
  end
  
  def set_previous_and_time_on_page
    previous_loads = visitor.loads.desc(:time)
    self.previous = previous_loads.find_by(uri_string: self.http_referer)
    if self.previous
      self.previous.next = self
      self.previous.time_on_page = (self.time - self.previous.time).round
      self.previous.save and self.save
    end
  end
end
