FactoryBot.define do
  factory :customer do
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    introduction { Faker::Lorem.characters(number: 20) }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :report do
    reports_id { 1 }
    reported_id { 1 }
    message { Faker::Lorem.characters(number: 10) }
  end
end