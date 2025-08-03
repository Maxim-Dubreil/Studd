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

require 'rails_helper'

RSpec.describe Icon, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
