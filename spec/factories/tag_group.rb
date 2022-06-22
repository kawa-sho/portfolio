FactoryBot.define do
  factory :tag_group do
    name { Faker::Lorem.characters(number: 5) }
  end
end