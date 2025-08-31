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

FactoryBot.define do
  factory :workspace do
    name { Faker::Lorem.words(number: 2).join(' ').capitalize }
    association :user
    association :icon, factory: :icon
    
    trait :without_icon do
      icon { nil }
    end
  end
end
