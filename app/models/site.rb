class SiteBase
  # This class is needed so that Site could
  # call super.with(collection: "site_#id_*")
  
  include Mongoid::Document
  
  has_many :visitors, inverse_of: :site
  has_many :loads, inverse_of: :site
  store_in collection: :sites
end
class Site < SiteBase
  has_and_belongs_to_many :users
  
  def visitors
    super.with(collection: "site_#{id}_visitors")
  end
  
  def visitors=(*attr)
    super.with(collection: "site_#{id}_visitors")
  end
  
  def loads
    super.with(collection: "site_#{id}_loads")
  end
  
  def loads=(*attr)
    super.with(collection: "site_#{id}_loads")
  end
  
  field :name
  embeds_many :domains
  accepts_nested_attributes_for :domains, allow_destroy: true
  
end

class Domain
  include Mongoid::Document
  embedded_in :site
  field :name
  
  def to_s
    name
  end
end


# # This is how to make Visitor.create(site: @site) persist to the correct collection,
# but using the same approach will not work for @site.visitors because in the latter case,
# collection will be looked up in the class level, which means there is no runtime info about
# the @base (i.e. @site) to get its ID
# 
# # Patch mongoid_gem_root/lib/mongoid/sessions.rb
# module Mongoid::Sessions
#   def collection
#     if self.class == Visitor
#       collname = "site_#{site_id}_visitors".to_sym
#       self.class.mongo_session[collname]
#     elsif self.class == Load
#       collname = "site_#{site_id}_loads".to_sym
#       self.class.mongo_session[collname]
#     else
#       self.class.collection
#     end
#   end
# end
# 
# # collection is probably cached somewhere else,
# # because s.visitors.collection give a Moped::Collection with correct name.
# # Or maybe @site.visitors calls some other collection() method, 
# # e.g. Mongoid::Persistence::Operations#collection()
# # What about concurrency issues?
# class Mongoid::Relations::Referenced::Many
#   def collection
#     kollection = klass.collection
#     if kollection.name == "visitors"
#       collname = "site_#{@base.id}_visitors".to_sym
#       klass.mongo_session[collname]
#     elsif kollection.name == "loads"
#       collname = "site_#{@base.id}_loads".to_sym
#       klass.mongo_session[collname]
#     else
#       klass.collection
#     end
#   end
# end