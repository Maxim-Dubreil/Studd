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

FactoryBot.define do
  factory :icon do
    name { Faker::Lorem.word }
    path { "/icons/#{Faker::Lorem.word}.svg" }
  end
end
