# == Schema Information
#
# Table name: workspaces
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  icon_id    :integer
#
# Indexes
#
#  index_workspaces_on_icon_id  (icon_id)
#  index_workspaces_on_user_id  (user_id)
#

class Workspace < ApplicationRecord
  belongs_to :user
  belongs_to :icon, optional: true
  has_one :raw_content, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3 }
  validates :user_id, presence: true
  has_many :flash_cards_sets, dependent: :destroy
  has_many :mindmaps, dependent: :destroy
  has_many :quizzes, dependent: :destroy
  has_many :quiz_sessions, dependent: :destroy
  has_many :study_sheets_sets, dependent: :destroy
end
