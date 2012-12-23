ActionView::Base.field_error_proc = Proc.new {|html, instance| html }
module ApplicationHelper
  def bootstrap_form_for(object, options = {}, &block)
    options[:builder] = BootstrapFormBuilder 
    options[:html] = {class: "form-horizontal"}
    form_for(object, options, &block)
  end
end