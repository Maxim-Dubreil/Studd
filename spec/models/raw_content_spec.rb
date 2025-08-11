# == Schema Information
#
# Table name: raw_contents
#
#  id           :integer          not null, primary key
#  workspace_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  content      :text
#
# Indexes
#
#  index_raw_contents_on_workspace_id  (workspace_id)
#

require 'rails_helper'

RSpec.describe RawContent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
