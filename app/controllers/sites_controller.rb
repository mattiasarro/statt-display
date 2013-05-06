class SitesController < InheritedResources::Base
  
  actions :all
  
  before_filter :authenticate_user!, except: [:show_ember]
  before_filter :ensure_ownership!, except: [:index, :new, :create, :show_ember]
  before_filter :do_not_create_empty_domain, only: :update
  
  def show
    @timeframe = Timeframe.new(params[:timeframe])
    @loads = Loads.new(@site, @timeframe)
    
    @graph = Graph.new(@loads, params[:nr_bars])
    @graph.site = @site # not needed after visitors() refactored
    
    @ui = UserInterface.new(params, @timeframe, @graph, @loads)
    render "graph/show"
  end
  
  def show_ember
    params = mock_params
    @site = Site.find(params[:id])
    @timeframe = Timeframe.new(params[:timeframe])
    @loads = Loads.new(@site, @timeframe)
    
    @graph = Graph.new(@loads, params[:nr_bars])
    @graph.site = @site # not needed after visitors() refactored
    
    @ui = UserInterface.new(params, @timeframe, @graph, @loads)
    render "graph/show_ember"
  end
  
  def mock_params
    g = {"nr_bars"=>"60", "type"=>"custom", :nr_bars => "60", :type => "custom"}
    t = {
      "from(3i)"=>"26", 
      "from(2i)"=>"1", 
      "from(1i)"=>"2013", 
      "from(4i)"=>"00", 
      "from(5i)"=>"00", 
      "to(3i)"=>"26", 
      "to(2i)"=>"1", 
      "to(1i)"=>"2013", 
      "to(4i)"=>"23", 
      "to(5i)"=>"59",
      "from(3i)".to_sym => "26", 
      "from(2i)".to_sym => "1", 
      "from(1i)".to_sym => "2013", 
      "from(4i)".to_sym => "00", 
      "from(5i)".to_sym => "00", 
      "to(3i)".to_sym => "26", 
      "to(2i)".to_sym => "1", 
      "to(1i)".to_sym => "2013", 
      "to(4i)".to_sym => "23", 
      "to(5i)".to_sym => "59"
    }
    {
      "graph" => g, 
      :graph  => g,
      "timeframe" => t,
      :timeframe  => t, 
      "id" => "5168608d763c55ea58000003",
      :id  => "5168608d763c55ea58000003"
    }
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
