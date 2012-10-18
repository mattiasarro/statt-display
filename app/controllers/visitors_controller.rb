class VisitorsController < ApplicationController
  inherit_resources
  respond_to :html
  actions :index
  
  before_filter lambda { Visitor.refresh_from_loads }, :only => :index
  
end
