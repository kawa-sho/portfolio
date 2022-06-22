FactoryBot.define do
  factory :report do
    message { Faker::Lorem.characters(number: 20) }
  end
end