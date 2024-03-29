require 'net/http'
require 'randomer'

sample_site_ID  = "50938a641b47f80651000000"
sample_site2_ID = "50938a641b47f80651002222"

conf = {
  mattias: { 
    visitor_id: Moped::BSON::ObjectId.new,
    user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4",
    screenx: 1440,
    browserx: 1170,
    browsery: 501
  }, 
  john: {
    visitor_id: Moped::BSON::ObjectId.new,
    user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4",
    screenx: 1440,
    browserx: 1170,
    browsery: 501
  },
  laura: {
    visitor_id: Moped::BSON::ObjectId.new,
    user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4",
    screenx: 1440,
    browserx: 1170,
    browsery: 501
  }
}

mattias = [
  {
    title: "Article on Rails page 2",
    ip: '6.234.228.145',
    cl_user_id: 'mattias-arro',
    cookie_id: '1',
    time: Time.at(60.seconds.ago),
    uri_string: 'http://mysite.com/blog/article-on-rails?pg=2',
    http_referer: "http://mysite.com/blog/article-on-rails"
  },
  {
    title: "Article on Rails",
    ip: '6.234.228.145',
    cl_user_id: 'mattias-arro',
    cookie_id: '1',
    time: Time.at(230.seconds.ago),
    uri_string: 'http://mysite.com/blog/article-on-rails',
    http_referer: "http://mysite.com/blog"
  },
  {
    title: "Blog",
    ip: '6.234.228.145',
    cl_user_id: 'mattias-arro',
    cookie_id: '1',
    time: Time.at(280.seconds.ago),
    uri_string: 'http://mysite.com/blog',
    http_referer: "http://mysite.com/"
  },
  {
    title: "MySite :: Home",
    ip: '6.234.228.145',
    cl_user_id: 'mattias-arro',
    cookie_id: '1',
    time: Time.at(300.seconds.ago),
    uri_string: 'http://mysite.com/',
    http_referer: "http://google.com/search?q=asdf"
  }
]
john = [
  {
    title: "Logitech Aspire #2398",
    ip: '33.27.174.114',
    cl_user_id: 'johnnydoe',
    cookie_id: '2',
    time: Time.at(5.minutes.ago),
    uri_string: 'http://mysite.com/categories/keyboards/products/logitech-aspier-2398',
    http_referer: "http://mysite.com/categories/keyboards/products"
  },
  {
    title: 'Keyboards',
    ip: '33.27.174.114',
    cl_user_id: 'johnnydoe',
    cookie_id: '2',
    time: Time.at(6.minutes.ago),
    uri_string: 'http://mysite.com/categories/keyboards/products',
    http_referer: "http://mysite.com/categories"
  },
  {
    title: 'Product Categories',
    ip: '33.27.174.114',
    cl_user_id: 'johnnydoe',
    cookie_id: '2',
    time: Time.at(8.minutes.ago),
    uri_string: 'http://mysite.com/categories',
    http_referer: "http://mysite.com/"
  },
  {
    title: 'MySite :: Home Page',
    ip: '33.27.174.114',
    cl_user_id: 'johnnydoe',
    cookie_id: '2',
    time: Time.at(9.minutes.ago),
    uri_string: 'http://mysite.com/',
    http_referer: "http://google.com/search?q=asdf"
  }
]
laura = [
  {
    title: 'Contact Us',
    ip: '67.46.150.111',
    cl_user_id: '',
    cookie_id: '3',
    time: Time.at(30.minutes.ago),
    uri_string: 'http://mysite.com/contact',
    http_referer: "http://mysite.com/"
  },
  {
    title: "MySite :: Home Page",
    ip: '67.46.150.111',
    cl_user_id: '',
    cookie_id: '3',
    time: Time.at(90.minutes.ago),
    uri_string: 'http://mysite.com/',
    http_referer: "http://google.com/search?q=asdf"
  }
]

users = [ :mattias, :laura, :john ]
Seeds = { mattias: mattias, laura: laura, john: john }

task :seed => :environment do
  drop_database
  u = create_user
  s = create_site(sample_site_ID, "Sample Site")
  
  s.domains.create(name: "example.com")
  u.sites << s
  u.save && s.save
  
  @base = Rails.configuration.collect_host
  
  @randomer = Randomer.new(
    nr_visitors: 20,
    nr_loads: 500,
    from: Time.at(60.minutes.ago),
    to: Time.at(Time.now),
    site: s
  )
  
  @randomer.visitors.each do |visitor_attr|
    create_visitor(@base, visitor_attr)
  end
  
  @randomer.loads.each do |load_attr|
    create_load(@base, load_attr)
  end
  
  # users.each do |u|
  #   visitor_attr = {
  #     visitor_id: conf[u][:visitor_id],
  #     site_id: s.id
  #   }
  #   create_visitor(@base, visitor_attr)
  #   
  #   Seeds[u].each do |attr|
  #     attr.merge!(conf[u])
  #     attr.merge!({site_id: s.id})
  #     
  #     create_load(@base, attr)
  #   end
  # end
end

def drop_database
  cmd = "db.dropDatabase();"
  Site.collection.database.command("$eval" => cmd, "nolock" => true)
end

def create_user
  u = User.create(email: 'mattias.arro@gmail.com')
  u.name = 'Mattias Arro'
  u.provider = 'twitter'
  u.uid = '14820811'
  u.save
  u
end

def create_site(sid, name)
  # cmd = 'db.sites.insert({ "_id": "'+ sid +'", "name": "'+ name +'"});'
  # Site.collection.database.command("$eval" => cmd, "nolock" => false)
  # Site.asc(:id).last
  Site.create(name: name).tap do |s|
    id_file_location = File.join(Rails.root, "..", "sample_site", "id.txt")
    File.open(id_file_location, "w") do |f|
      f.write s.id
    end
  end
end

def create_visitor(base, attr)
  url = base + "/new_visitor.png?" + attr.to_query
  puts "#{url}\n"
  puts Net::HTTP.get_response(URI(url))
end

def create_load(base, attr)
  url = base + "/track.png?" + attr.to_query
  puts "#{url}\n"
  puts Net::HTTP.get_response(URI(url)).body
end
