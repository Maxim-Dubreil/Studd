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

class Quiz < ApplicationRecord
  belongs_to :workspace
  has_many :quiz_sessions, dependent: :destroy
end
