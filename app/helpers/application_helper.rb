ActionView::Base.field_error_proc = Proc.new {|html, instance| html }
module ApplicationHelper
  def bootstrap_form_for(object, options = {}, &block)
    options[:builder] = BootstrapFormBuilder 
    options[:html] = {class: "form-horizontal"}
    form_for(object, options, &block)
  end
  
  def ember_site_path(site)
    from = Date.today.to_time.to_i
    to = Time.now.to_i
    "/ember/#/sites/#{site.id}/chart/60/#{from}/#{to}/loads/page/1"
  end
end