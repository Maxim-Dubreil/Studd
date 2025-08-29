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

require 'rails_helper'

RSpec.describe Workspace, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
