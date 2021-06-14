require 'rails_helper'

RSpec.describe InvoiceItem do

  describe 'relationships' do
    it {should belong_to :invoice}
    it {should belong_to :item}
    it { should have_many(:bulk_discounts).through(:item) }
  end

  describe 'class methods' do
    describe '.total_revenue' do
      it 'returns expected total revenue of all invoice items' do

        expect(InvoiceItem.total_revenue).to eq(457341633)
      end
    end
  end

  describe 'instance methods' do
    describe "#find_discount" do 
      it 'finds discount of greatest value applied to invoice_item' do
        merchant = create(:mock_merchant)
        customer = create(:mock_customer)
        item = create(:mock_item, merchant: merchant)
        invoice = create(:mock_invoice, customer: customer)
        discount = create(:mock_bulk_discount, threshold: 10, percent_discount: 20, merchant: merchant)
        discount_2 = create(:mock_bulk_discount, threshold: 10, percent_discount: 50, merchant: merchant)
        discount_3 = create(:mock_bulk_discount, threshold:  5, percent_discount: 45, merchant: merchant)
        invoice_item = create(:mock_invoice_item, unit_price: 100, quantity: 10, invoice: invoice, item: item)

        expect(invoice_item.find_discount).to eq(discount_2)
      end
    end
  end
end
