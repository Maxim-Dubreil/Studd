FactoryBot.define do
  factory :workspace do
    name { Faker::Lorem.words(number: 2).join(' ').capitalize }
    association :user
    association :icon, factory: :icon
    
    trait :without_icon do
      icon { nil }
    end
  end
end
