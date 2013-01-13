# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do   
  factory :map do
    sequence(:name) { |n| "map #{n}" }
    image_url "http://static.unchartedleague.com/maps/chateau.png"
  end
end
