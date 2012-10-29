module SitesHelper
  
  def display_tracking_code(ver)
    location = File.new(File.join([Rails.root, "app", "views", "tracking_codes", "ver-#{ver}.js"])).read
    template = ERB.new location, nil, "%"
    template.result(binding)
  end
  
end