# == Schema Information
#
# Table name: quiz_sessions
#
#  id                  :integer          not null, primary key
#  workspace_id        :integer          not null
#  quiz_id             :integer          not null
#  user_id             :integer          not null
#  started_at          :datetime         not null
#  completed_at        :datetime
#  duration_seconds    :integer          default(0)
#  score               :integer          default(0)
#  total_questions     :integer          not null
#  accuracy_percentage :decimal(5, 2)
#  quiz_mode           :string           not null
#  session_type        :string           default("standard")
#  metadata            :json
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class QuizSession < ApplicationRecord
  belongs_to :workspace
  belongs_to :quiz
  belongs_to :user
  has_many :quiz_session_answers, dependent: :destroy

  accepts_nested_attributes_for :quiz_session_answers, allow_destroy: true

  validates :quiz_mode, inclusion: { in: %w[quiz test] }
  validates :session_type, inclusion: { in: %w[standard review challenge] }
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_questions, presence: true, numericality: { greater_than: 0 }

  scope :completed, -> { where.not(completed_at: nil) }
  scope :in_progress, -> { where(completed_at: nil) }
  scope :by_mode, ->(mode) { where(quiz_mode: mode) }
  scope :recent, -> { order(created_at: :desc) }

  before_save :calculate_accuracy_percentage
  before_save :calculate_duration, if: :completed_at_changed?

  def completed?
    completed_at.present?
  end

  def in_progress?
    !completed?
  end

  def accuracy
    return 0 if total_questions.zero?
    (score.to_f / total_questions * 100).round(2)
  end

  def duration_formatted
    return "En cours..." unless completed?
    
    hours = duration_seconds / 3600
    minutes = (duration_seconds % 3600) / 60
    seconds = duration_seconds % 60

    if hours > 0
      "#{hours}h #{minutes}m #{seconds}s"
    elsif minutes > 0
      "#{minutes}m #{seconds}s"
    else
      "#{seconds}s"
    end
  end

  def performance_level
    case accuracy
    when 90..100 then 'excellent'
    when 75..89 then 'good'
    when 60..74 then 'average'
    else 'needs_improvement'
    end
  end

  def improvement_from_previous
    previous_session = user.quiz_sessions
                          .where(workspace: workspace)
                          .where('created_at < ?', created_at)
                          .order(created_at: :desc)
                          .first

    return nil unless previous_session&.completed?
    
    accuracy - previous_session.accuracy
  end

  private

  def calculate_accuracy_percentage
    self.accuracy_percentage = accuracy
  end

  def calculate_duration
    return unless started_at && completed_at
    self.duration_seconds = (completed_at - started_at).to_i
  end
end
