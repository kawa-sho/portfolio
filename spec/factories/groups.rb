FactoryBot.define do
  factory :group do
    name { Faker::Lorem.characters(number: 10) }
    introduction { Faker::Lorem.characters(number: 20) }
  end
end