FactoryBot.define do
  factory :mock_invoice_item, class: InvoiceItem do
    quantity { Faker::Number.within(range: 1..20) }
    unit_price { Faker::Number.within(range: 1..200) }
    status { [0,1,2].sample }
  end
end
