def random_ip
  Array.new(4){rand(256)}.join('.')
end

FactoryGirl.define do
  
  factory :user_load do
    ip { random_ip }
    user_id "john-doe"
    time { Time.now }
  end
  
  factory :visitor_load do
    ip  { random_ip } # random IP
    user_id ""
    time { Time.now }
  end
  
end