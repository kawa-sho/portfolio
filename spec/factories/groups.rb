FactoryBot.define do
  factory :group do
    # customer_id
    name { Faker::Lorem.characters(number: 10) }
    introduction { Faker::Lorem.characters(number: 20) }
  end
end