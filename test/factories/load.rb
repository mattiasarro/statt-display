def random_ip
  Array.new(4){rand(256)}.join('.')
end

FactoryGirl.define do
  
  factory :load do
    ip { random_ip }
    cl_user_id "john-doe"
    time { Time.now }
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