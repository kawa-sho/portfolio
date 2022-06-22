FactoryBot.define do
  factory :group_message do
    message { Faker::Lorem.characters(number: 20) }
  end
end