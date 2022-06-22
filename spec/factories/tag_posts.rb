FactoryBot.define do
  factory :tag_post do
    name { Faker::Lorem.characters(number: 5) }
  end
end