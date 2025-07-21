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
#
# Indexes
#
#  index_workspaces_on_user_id  (user_id)
#

class Workspace < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :user_id, presence: true
end
