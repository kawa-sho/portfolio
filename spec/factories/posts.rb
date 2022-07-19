FactoryBot.define do
  factory :post do
    # customer_id
    post { Faker::Lorem.characters(number: 20) }
  end
end