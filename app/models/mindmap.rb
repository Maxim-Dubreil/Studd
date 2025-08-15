# == Schema Information
#
# Table name: mindmaps
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
#  index_mindmaps_on_workspace_id  (workspace_id)
#

class Mindmap < ApplicationRecord
  belongs_to :workspace
end
