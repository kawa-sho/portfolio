FactoryBot.define do
  factory :group_message do
    # customer_id
    # group_id
    message { Faker::Lorem.characters(number: 20) }
  end
end