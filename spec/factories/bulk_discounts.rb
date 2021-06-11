FactoryBot.define do
  factory :mock_bulk_discount, class: BulkDiscount  do
    threshold { rand(1..10) }
    percent_discount { rand(1..99) }
    name { Faker::Commerce.promotion_code }

    association :merchant, factory: :merchants
  end
end
