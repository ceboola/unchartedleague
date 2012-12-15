# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment_for_article, :class => "Comment" do
    owner_id 2 # normal user from users factory
    commentable_type "Article"
    body "comment"
  end  
end