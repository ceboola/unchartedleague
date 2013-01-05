# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :captain_team_participation, :class => "TeamParticipation" do
    user_id 2
    team_id 1
    role 0
    active true
  end
  
  factory :team_participation do
    association :user, factory: :random_user
    team_id 1
    role 1
    active true
  end
end
