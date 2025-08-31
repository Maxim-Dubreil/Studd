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

FactoryBot.define do
  factory :raw_content do
    association :workspace
    content { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    
    trait :with_file do
      content { nil }
      after(:build) do |raw_content|
        raw_content.file.attach(
          io: StringIO.new("Sample file content"),
          filename: "test_file.txt",
          content_type: "text/plain"
        )
      end
    end
  end
end
