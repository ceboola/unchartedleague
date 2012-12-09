# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :author, class: User do
    id 666
    psn_name "author"
    email "author@gmail.com"
    password "jkl008AB"
  end
  
  factory :article do
    title "Title"
    content "Content"
    author_id 666
    published TRUE
  end
  
  factory :article_with_author, :class => "Article" do
    title "Title"
    content "Content"
    published TRUE
    author
  end
end
