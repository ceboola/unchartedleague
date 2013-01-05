# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin, :class => "User" do
    id 1
    psn_name "miciek"
    email "miciek@gmail.com"
    password "jkl008AB"
  end
  
  factory :user do
    id 2
    psn_name "user_normal"
    email "user@normal.com"
    password "aa22jkl008AB"
  end
  
  factory :random_user, :class => "User" do
    sequence(:psn_name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@unchartedleague.com" }
    password "aa22jkl008AB"
  end
end
