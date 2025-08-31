FactoryBot.define do
  factory :quiz do
    association :workspace
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    content { 
      {
        questions: [
          {
            question: Faker::Lorem.question,
            options: Faker::Lorem.words(number: 4),
            correct_answer: 0
          }
        ]
      }
    }
  end
end
