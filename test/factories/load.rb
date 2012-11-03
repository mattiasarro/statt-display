def random_ip
  Array.new(4){rand(256)}.join('.')
end

FactoryGirl.define do
  
  factory :load do
    ip { random_ip }
    cl_user_id "john-doe"
    time { Time.now }
    uri_string "http://example.com/"
    http_referer "http://google.com/search?q=asdf"
    title "Example Site :: Home"
  end
    
  factory :user_load do
    ip { random_ip }
    cl_user_id "john-doe"
    time { Time.now }
  end
  
  factory :visitor_load do
    ip  { random_ip } # random IP
    cl_user_id ""
    time { Time.now }
  end
  
end