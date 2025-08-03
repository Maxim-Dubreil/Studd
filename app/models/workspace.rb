# == Schema Information
#
# Table name: workspaces
#
#  id         :integer          not null, primary key
#  name       :string
#  icon       :string
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
end
