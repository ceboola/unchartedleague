# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do  
  factory :team do
    id 1
    name "Normal Team"
    tag "nt"
    description "the best"
  end
  
  factory :random_team, :class => "Team" do
    sequence(:name) { |n| "team #{n}" }
    sequence(:tag) { |n| "#{n}" }
    description "aa22jkl008AB"
  end
end
