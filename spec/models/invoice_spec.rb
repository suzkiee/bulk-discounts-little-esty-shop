require 'rails_helper'

RSpec.describe Invoice do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many :transactions }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end

  describe 'class methods' do
    describe '#filter_by_unshipped_order_by_age' do
      @merchant = Merchant.create!(name: 'Sally Handmade')
      @merchant_2 = Merchant.create!(name: 'Billy Mandmade')
      @item =  @merchant.items.create!(name: 'Qui Essie', description: 'Lorem ipsim', unit_price: 75107)
      @item_2 =  @merchant.items.create!(name: 'Essie', description: 'Lorem ipsim', unit_price: 75107)
      @item_3 = @merchant_2.items.create!(name: 'Glowfish Markdown', description: 'Lorem ipsim', unit_price: 55542)
      @customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka') 
      @invoice = Invoice.create!(customer_id: @customer.id, status: 'completed')
      @invoice_2 = Invoice.create!(customer_id: @customer.id, status: 'completed')
      InvoiceItem.create!(item_id: @item.id, invoice_id: @invoice.id, quantity: 539, unit_price: 13635, status: 1)
      InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice.id, quantity: 539, unit_price: 13635, status: 1)
      InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice.id, quantity: 539, unit_price: 13635, status: 1)

      it 'returns all invoices with unshipped items sorted by creation date' do
        # expect(Invoice.filter_by_unshipped_order_by_age.count("distinct invoices.id")).to eq(45)
        expect(Invoice.filter_by_unshipped_order_by_age.first.id).to eq(10)
      end
    end
  end

  describe 'instance methods' do
    # Test pulls instance from test db to test against
    it 'has array of available status options' do
      single_invoice = Invoice.last
      expect(single_invoice.statuses).to eq ['in progress', 'completed', 'cancelled']
    end

    it 'calculates total potential revenue' do
      single_invoice = Invoice.last
      total_revenue = single_invoice.invoice_items.total_revenue # utilizes class method from InvoiceItems
      expect(single_invoice.revenue).to eq total_revenue
    end

    describe '.total_discount' do
      before :each do 
        @merchant = create(:mock_merchant)
        @customer = create(:mock_customer)
        @item = create(:mock_item, merchant: @merchant)
        @item_2 = create(:mock_item, merchant: @merchant)
        @invoice = create(:mock_invoice, customer: @customer)
      end

      it 'calculates total discounted revenue if at least one item hits the threshold' do
        discount = create(:mock_bulk_discount, threshold: 10, percent_discount: 20, merchant: @merchant)
        invoice_item = create(:mock_invoice_item, unit_price: 100, quantity: 10, invoice: @invoice, item: @item)
        invoice_item_2 = create(:mock_invoice_item, unit_price: 100, quantity: 5, invoice: @invoice, item: @item_2)
        
        expect(@invoice.total_discount).to eq(200)
      end

      it 'does not calculate total discounted revenue if no items hit the threshold' do
        discount = create(:mock_bulk_discount, threshold: 10, percent_discount: 20, merchant: @merchant)
        invoice_item = create(:mock_invoice_item, unit_price: 100, quantity: 5, invoice: @invoice, item: @item)
        invoice_item_2 = create(:mock_invoice_item, unit_price: 100, quantity: 5, invoice: @invoice, item: @item_2)
        
        expect(@invoice.total_discount).to eq(0)
      end

      it 'calculates sum of each discount applied only to items that meet the threshold amount' do
        discount = create(:mock_bulk_discount, threshold: 10, percent_discount: 20, merchant: @merchant)
        discount_2 = create(:mock_bulk_discount, threshold: 15, percent_discount: 30, merchant: @merchant)
        invoice_item = create(:mock_invoice_item, unit_price: 100, quantity: 12, invoice: @invoice, item: @item)
        invoice_item_2 = create(:mock_invoice_item, unit_price: 100, quantity: 15, invoice: @invoice, item: @item_2)
        
        expect(@invoice.total_discount).to eq(690)
      end

      it 'calculates total discounted revenue using the max discount that can be applied to each item that meet the threshold amount' do
        discount = create(:mock_bulk_discount, threshold: 10, percent_discount: 20, merchant: @merchant)
        discount_2 = create(:mock_bulk_discount, threshold: 15, percent_discount: 15, merchant: @merchant)
        invoice_item = create(:mock_invoice_item, unit_price: 100, quantity: 12, invoice: @invoice, item: @item)
        invoice_item_2 = create(:mock_invoice_item, unit_price: 100, quantity: 15, invoice: @invoice, item: @item_2)
        
        expect(@invoice.total_discount).to eq(540)
      end

      it 'only applies discount to itesm that belong to the merchant with the discount' do
        merchant_2 = create(:mock_merchant)
        item_3 = create(:mock_item, merchant: merchant_2)
        discount = create(:mock_bulk_discount, threshold: 10, percent_discount: 20, merchant: @merchant)
        discount_2 = create(:mock_bulk_discount, threshold: 15, percent_discount: 30, merchant: @merchant)
        invoice_item = create(:mock_invoice_item, unit_price: 100, quantity: 12, invoice: @invoice, item: @item)
        invoice_item_2 = create(:mock_invoice_item, unit_price: 100, quantity: 15, invoice: @invoice, item: @item)
        invoice_item_3 = create(:mock_invoice_item, unit_price: 100, quantity: 15, invoice: @invoice, item: item_3)
        
        expect(@invoice.total_discount).to eq(690)
      end
    end
  end
end
