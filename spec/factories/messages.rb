FactoryBot.define do
  factory :message do
    message { Faker::Lorem.characters(number: 20) }
  end
end