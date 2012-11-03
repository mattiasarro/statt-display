FactoryGirl.define do
  
  factory :site do
    name 'My Sample Site'
    domains { [FactoryGirl.build(:domain)] }
  end
  
  factory :site_with_content, class: Site do
    name 'My Sample Site'
    domains { [FactoryGirl.build(:domain)] }
    visitors { [FactoryGirl.build(:visitor)] }
    loads { [FactoryGirl.build(:load, visitor: visitors.first)] }
  end
  
  factory :domain do
    name 'example.com'
  end
  
end