FactoryBot.define do
  factory :report do
    # reports_id
    # reported_id
    message { Faker::Lorem.characters(number: 20) }
  end
end