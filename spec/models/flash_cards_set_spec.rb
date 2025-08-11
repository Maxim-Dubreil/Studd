# == Schema Information
#
# Table name: flash_cards_sets
#
#  id         :integer          not null, primary key
#  name       :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe FlashCardsSet, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
