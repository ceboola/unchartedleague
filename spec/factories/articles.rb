# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :author, class: User do
    id 1
    psn_name "miciek"
    email "miciek@gmail.com"
    password "jkl008AB"
  end
  
  factory :article do
    title "Title"
    content "Content"
    author
  end
end
