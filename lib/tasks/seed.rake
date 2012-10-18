require 'net/http'

mattias = [
  {
    ip: '6.234.228.145',
    cl_user_id: 'mattias-arro',
    cookie_id: '1',
    time: Time.at(60.seconds.ago),
    path: '/blog/article-on-rails?pg=2'
  },
  {
    ip: '6.234.228.145',
    cl_user_id: 'mattias-arro',
    cookie_id: '1',
    time: Time.at(230.seconds.ago),
    path: '/blog/article-on-rails'
  },
  {
    ip: '6.234.228.145',
    cl_user_id: 'mattias-arro',
    cookie_id: '1',
    time: Time.at(280.seconds.ago),
    path: '/blog'
  },
  {
    ip: '6.234.228.145',
    cl_user_id: 'mattias-arro',
    cookie_id: '1',
    time: Time.at(300.seconds.ago),
    path: '/'
  }
]

john = [
  {
    ip: '33.27.174.114',
    cl_user_id: 'johnnydoe',
    cookie_id: '2',
    time: Time.at(5.minutes.ago),
    path: '/categories/keyboards/products/logitech-aspier-2398'
  },
  {
    ip: '33.27.174.114',
    cl_user_id: 'johnnydoe',
    cookie_id: '2',
    time: Time.at(6.minutes.ago),
    path: '/categories/keyboards/products'
  },
  {
    ip: '33.27.174.114',
    cl_user_id: 'johnnydoe',
    cookie_id: '2',
    time: Time.at(8.minutes.ago),
    path: '/categories'
  },
  {
    ip: '33.27.174.114',
    cl_user_id: 'johnnydoe',
    cookie_id: '2',
    time: Time.at(9.minutes.ago),
    path: '/'
  }
]
laura = [
  {
    ip: '67.46.150.111',
    cl_user_id: '',
    cookie_id: '3',
    time: Time.at(30.minutes.ago),
    path: '/contact'
  },
  {
    ip: '67.46.150.111',
    cl_user_id: '',
    cookie_id: '3',
    time: Time.at(90.minutes.ago),
    path: '/'
  }
]

Seeds = [ mattias, john, laura].flatten

task :seed => :environment do
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.orm = "mongoid"
  DatabaseCleaner.clean
  
  base  = Rails.configuration.collect_host
  base += '/track?'
  
  Seeds.each do |attr|
    puts Net::HTTP.get_response(URI(base + attr.to_query)).body
  end
end