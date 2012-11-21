module SitesHelper
  
  def display_tracking_code(ver)
    location = File.new(File.join([Rails.root, "app", "views", "tracking_codes", "ver-#{ver}.js"])).read
    template = ERB.new location, nil, "%"
    template.result(binding)
  end
  
  def format_time_on_page(top)
    if top
      if top >= 60
        distance_of_time_in_words top
      else
        top = top.round
        top.to_s + " second" + ("s" unless top == 1).to_s
      end
    end
  end
  
end