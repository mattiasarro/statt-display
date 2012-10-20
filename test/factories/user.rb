FactoryGirl.define do
  
  factory :user do
    name 'John Doe'
    email 'john@doe.com'
    provider 'twitter'
    uid '00000000'
  end
  
  factory :user2, class: User do
    name 'John Smith'
    email 'john@smith.com'
    provider 'twitter'
    uid '00000001'
  end
  
  factory :admin, class: User do
    name 'Mattias Arro'
    email 'mattias.arro@gmail.com'
    provider 'twitter'
    uid '14820811'
  end
  
end