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

class FlashCardsSet < ApplicationRecord
  belongs_to :workspace

  # content est en jsonb ; Rails ≥ 7 sait le caster automatiquement
  attribute :content, :jsonb, default: []

  validates :name, presence: true
end
