class SitesController < InheritedResources::Base
  
  actions :all
  
  before_filter :authenticate_user!
  before_filter  :ensure_ownership!, except: [:index, :new, :create]
  before_filter :do_not_create_empty_domain, only: :update
    
  protected
  
    def begin_of_association_chain
      current_user
    end
    
  private
    
    def do_not_create_empty_domain
      i = params[:site][:domains_attributes].keys.last
      new_site_attr = params[:site][:domains_attributes][i]
      if new_site_attr[:name].empty?
        params[:site][:domains_attributes].delete(i)
      end
      update! { edit_site_path(resource) }
    end

    def ensure_ownership!
      @site = Site.find(params[:id])
      unless @site.users.include?(current_user)
        redirect_to root_url, :notice => "You don't have access to this site."
      end
    end
    
  
end
