FactoryBot.define do
  factory :icon do
    name { Faker::Lorem.word }
    path { "/icons/#{Faker::Lorem.word}.svg" }
  end
end
