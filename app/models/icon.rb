# == Schema Information
#
# Table name: icons
#
#  id         :integer          not null, primary key
#  name       :string
#  path       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Icon < ApplicationRecord
  has_many :workspaces
end
