class BootstrapFormBuilder < ActionView::Helpers::FormBuilder

  def fieldset(legend_text)
    t = @template
    t.content_tag(:fieldset) do
      t.concat t.content_tag(:legend, legend_text)
      yield
    end
  end
  
  %w[text_field text_area email_field password_field collection_select].each do |method_name|
    define_method(method_name) do |name, *args|
      t = @template
      t.content_tag(:div, class: "control-group") do
        t.concat(field_label(name, *args))
        t.concat(
          t.content_tag(:div, class: "controls") do
            super(name, *args)
          end
        )
      end
    end
  end
  
  def submit(value)
    @template.content_tag(:div, class: "control-group") do
      @template.content_tag(:div, class: "controls") do
        @template.content_tag(:button, class: "btn", type: "submit") do
          value
        end
      end
    end
  end
  
private
  
  def field_label(name, *args)
    options = args.extract_options!
    label(name, options[:label], class: "control-label")
  end
  
  def objectify_options(options)
    super.except(:label)
  end
 
end