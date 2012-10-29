FactoryGirl.define do
  
  factory :site do
    name 'My Sample Site'
    domains { [FactoryGirl.build(:domain)] }
  end
  
  factory :domain do
    name 'example.com'
  end
  
end