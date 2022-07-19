FactoryBot.define do
  factory :post_comment do
    # customer_id
    # post_id
    comment { Faker::Lorem.characters(number: 20) }
  end
end