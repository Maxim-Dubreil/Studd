# == Schema Information
#
# Table name: study_sheets_sets
#
#  id           :integer          not null, primary key
#  workspace_id :integer          not null
#  name         :string
#  content      :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_study_sheets_sets_on_workspace_id  (workspace_id)
#

class StudySheetsSet < ApplicationRecord
  belongs_to :workspace

  # content est en jsonb ; Rails ≥ 7 sait le caster automatiquement
  attribute :content, :jsonb, default: []

  validates :name, presence: true
end
