FactoryBot.define do
  factory :message do
    # customer_id
    # room_id
    message { Faker::Lorem.characters(number: 20) }
  end
end