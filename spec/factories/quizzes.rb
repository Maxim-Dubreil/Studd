# == Schema Information
#
# Table name: quizzes
#
#  id           :integer          not null, primary key
#  workspace_id :integer          not null
#  title        :string
#  description  :text
#  content      :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_quizzes_on_workspace_id  (workspace_id)
#

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
