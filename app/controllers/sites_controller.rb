class SitesController < InheritedResources::Base
  
  actions :all
  
  before_filter :authenticate_user!
  before_filter :ensure_ownership!, except: [:index, :new, :create]
  before_filter :do_not_create_empty_domain, only: :update
  
  def show
    @graph = Graph.factory(params[:graph])
    @graph.site = @site
  end
  
  def update
    do_not_create_empty_domain
    update! { edit_site_path(resource) }
  end
  
  def tracking_code
    @last_load = @site.loads.asc(:time).last
  end
    
  protected
  
    def begin_of_association_chain
      current_user
    end
    
  private

    def ensure_ownership!
      @site = Site.find(params[:id])
      unless @site.users.include?(current_user)
        redirect_to root_url, :notice => "You don't have access to this site."
      end
    end
    
    # Removes the last element of domain_attributes hash if it has no
    # 'name' set (that would be caused by the New Domain text field)
    def do_not_create_empty_domain
      domain_attributes = params[:site][:domains_attributes]
      return unless domain_attributes
      i = domain_attributes.keys.last
      
      if domain_attributes[i][:name].empty?
        domain_attributes.delete(i)
      end
    end
end
