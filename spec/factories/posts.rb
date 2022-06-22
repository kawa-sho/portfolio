FactoryBot.define do
  factory :post do
    post { Faker::Lorem.characters(number: 20) }
  end
end