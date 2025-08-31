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
