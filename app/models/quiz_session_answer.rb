# == Schema Information
#
# Table name: quiz_session_answers
#
#  id                  :integer          not null, primary key
#  quiz_session_id     :integer          not null
#  question_id         :string           not null
#  question_text       :text             not null
#  question_type       :string           not null
#  user_answers        :json             not null
#  correct_answers     :json             not null
#  is_correct          :boolean          not null
#  time_spent_seconds  :integer
#  attempts_count      :integer          default(1)
#  explanation_shown   :text
#  analytics_data      :json
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class QuizSessionAnswer < ApplicationRecord
  belongs_to :quiz_session

  validates :question_id, presence: true
  validates :question_text, presence: true
  validates :question_type, inclusion: { in: %w[multiple_choice true_false fill_in_blank] }
  validates :user_answers, presence: true
  validates :correct_answers, presence: true
  validates :is_correct, inclusion: { in: [true, false] }

  scope :correct, -> { where(is_correct: true) }
  scope :incorrect, -> { where(is_correct: false) }
  scope :by_type, ->(type) { where(question_type: type) }

  def user_answers_text
    case question_type
    when 'true_false'
      user_answers.first == 'true' ? 'Vrai' : 'Faux'
    when 'fill_in_blank'
      user_answers.first || 'Non répondu'
    when 'multiple_choice'
      user_answers.join(', ')
    else
      user_answers.join(', ')
    end
  end

  def correct_answers_text
    case question_type
    when 'true_false'
      correct_answers.first == 'true' ? 'Vrai' : 'Faux'
    when 'fill_in_blank'
      correct_answers.first
    when 'multiple_choice'
      correct_answers.join(', ')
    else
      correct_answers.join(', ')
    end
  end

  def difficulty_indicator
    return 'easy' if time_spent_seconds && time_spent_seconds < 30 && attempts_count == 1
    return 'hard' if time_spent_seconds && time_spent_seconds > 120 || attempts_count > 2
    'medium'
  end

  private
end
