FactoryBot.define do
  factory :mock_merchants do
    name { Faker::FunnyName.three_word_name }
  end
end
