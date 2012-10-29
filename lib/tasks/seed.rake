require 'net/http'

mattias = [
  {
    ip: '6.234.228.145',
    cl_user_id: 'mattias-arro',
    cookie_id: '1',
    time: Time.at(60.seconds.ago),
    uri_string: 'http://mysite.com/blog/article-on-rails?pg=2',
    http_referer: "http://mysite.com/blog/article-on-rails"
  },
  {
    ip: '6.234.228.145',
    cl_user_id: 'mattias-arro',
    cookie_id: '1',
    time: Time.at(230.seconds.ago),
    uri_string: 'http://mysite.com/blog/article-on-rails',
    http_referer: "http://mysite.com/blog"
  },
  {
    ip: '6.234.228.145',
    cl_user_id: 'mattias-arro',
    cookie_id: '1',
    time: Time.at(280.seconds.ago),
    uri_string: 'http://mysite.com/blog',
    http_referer: "http://mysite.com/"
  },
  {
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
    ip: '33.27.174.114',
    cl_user_id: 'johnnydoe',
    cookie_id: '2',
    time: Time.at(5.minutes.ago),
    uri_string: 'http://mysite.com/categories/keyboards/products/logitech-aspier-2398',
    http_referer: "http://mysite.com/categories/keyboards/products"
  },
  {
    ip: '33.27.174.114',
    cl_user_id: 'johnnydoe',
    cookie_id: '2',
    time: Time.at(6.minutes.ago),
    uri_string: 'http://mysite.com/categories/keyboards/products',
    http_referer: "http://mysite.com/categories"
  },
  {
    ip: '33.27.174.114',
    cl_user_id: 'johnnydoe',
    cookie_id: '2',
    time: Time.at(8.minutes.ago),
    uri_string: 'http://mysite.com/categories',
    http_referer: "http://mysite.com/"
  },
  {
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
    ip: '67.46.150.111',
    cl_user_id: '',
    cookie_id: '3',
    time: Time.at(30.minutes.ago),
    uri_string: 'http://mysite.com/contact',
    http_referer: "http://mysite.com/"
  },
  {
    ip: '67.46.150.111',
    cl_user_id: '',
    cookie_id: '3',
    time: Time.at(90.minutes.ago),
    uri_string: 'http://mysite.com/',
    http_referer: "http://google.com/search?q=asdf"
  }
]

Seeds = [ mattias, john, laura].flatten

task :seed => :environment do
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.orm = "mongoid"
  DatabaseCleaner.clean
  
  base  = Rails.configuration.collect_host
  base += '/track?'
  
  u = User.create(email: 'mattias.arro@gmail.com')
  u.name = 'Mattias Arro'
  u.provider = 'twitter'
  u.uid = '14820811'
  u.save

  s = Site.create(name: "Example Site")
  s.domains.create(name: "example.com")
  u.sites << s
  u.save && s.save
  
  Seeds.each do |attr|
    attr[:site_id] = s.id
    puts Net::HTTP.get_response(URI(base + attr.to_query)).body
  end
  
end