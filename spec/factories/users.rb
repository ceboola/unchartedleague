# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin, :class => "User" do
    id 1
    psn_name "miciek"
    email "miciek@gmail.com"
    password "jkl008AB"
  end
  
  factory :user do
    id 3636
    psn_name "user_normal"
    email "user@normal.com"
    password "aa22jkl008AB"
  end
end
