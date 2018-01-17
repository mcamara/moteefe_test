FactoryBot.define do
  factory :search do
    email { Faker::Internet.email }
    date { Time.zone.now }
    search_params { { name: 'blah' } }
  end
end
