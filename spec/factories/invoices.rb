FactoryBot.define do
  factory :mock_invoices do
    status { [0,1,2].sample }
    
    associations :customer, factory: :mock_customers
  end
end
