# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :competition do
    id 1
    name "Competition123"
    description "description of competition"
    regulations "RULEZ"
    season 1
    starts Date.new(2013, 1, 1)
    ends Date.current.tomorrow
    signup_ends Date.current.tomorrow
  end  
end
