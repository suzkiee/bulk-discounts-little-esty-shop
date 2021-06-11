FactoryBot.define do
  factory :mock_bulk_discount do
    threshold { Faker::Number.between(from: 1, to: 10) }
    discount { Faker::Number.between(from: 1, to: 99)}
    name { Faker::Commerce.promotion_code }

    association :merchant, factory: :mock_merchants
  end
end
