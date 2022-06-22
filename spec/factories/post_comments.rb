FactoryBot.define do
  factory :post_comment do
    comment { Faker::Lorem.characters(number: 20) }
  end
end