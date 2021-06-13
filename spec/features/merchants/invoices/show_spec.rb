# spec/features/merchants/invoices/show_spec

require 'rails_helper'

RSpec.describe 'Merchant invoice show page' do
  before :each do
    @merchant = create(:mock_merchant)
    @merchant_2 = create(:mock_merchant)
    @item = create(:mock_item, merchant: @merchant)
    @item_2 = create(:mock_item, merchant: @merchant)
    @item_3 = create(:mock_item, merchant: @merchant_2) 
    @customer = create(:mock_customer, first_name: 'Joey', last_name: 'Ondricka')
    @invoice = create(:mock_invoice, customer: @customer)
    @invoice_2 = create(:mock_invoice, customer: @customer)
    @invoice_item = create(:mock_invoice_item, item: @item, invoice: @invoice, quantity: 5, unit_price: 1200) 
    invoice_item_2 = create(:mock_invoice_item, item: @item_2, invoice: @invoice, quantity: 10, unit_price: 1000) 
    invoice_item_3 = create(:mock_invoice_item, item: @item_3, invoice: @invoice_2, quantity: 12, unit_price: 200)
    @discount = create(:mock_bulk_discount, threshold: 10, percent_discount: 50, merchant: @merchant)
    visit merchant_invoice_path(@merchant, @invoice)
  end
 
  describe 'display' do
    it 'shows invoice and its attributes' do
      created_at = @invoice.created_at.strftime('%A, %B %d, %Y')

      expect(page).to have_content("INVOICE # #{@invoice.id}")
      expect(page).to_not have_content("INVOICE # #{@invoice_2.id}")
      expect(page).to have_content("#{@invoice.status}")
      expect(page).to have_content("#{created_at}")
    end

    it 'lists all items and item attributes on the invoice' do
      
      expect(page).to have_content("#{@item.name}")
      expect(page).to have_content("#{@item_2.name}")
      expect(page).to_not have_content("#{@item_3.name}")
      expect(page).to have_content("#{@invoice_item.quantity}")
      expect(page).to have_content("$1,200.00")
    end

    it 'can update items status through dropdown list' do

      expect(page).to have_button("Save")
      
      within first('.status-update') do
        expect(page).to have_content("packaged")

        select "shipped"
        click_on "Save"
      end

      expect(page).to have_content("shipped")
      expect(current_path).to eq("/merchants/#{@merchant.id}/invoices/#{@invoice.id}")
    end

    it 'lists total revenue of all items on invoice' do 
      
      expect(page).to have_content("Expected Total Revenue: $160.00")
    end

    it 'lists total discounted revenue for merchant' do
      total_discounted_revenue = @invoice.revenue.to_f/100 - @invoice.total_discount.to_f/100
      expect(page).to have_content("Expected Total Discounted Revenue: $#{total_discounted_revenue}")
    end

    it 'links to applied discount show page' do

      click_on(@discount.name)

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount))
    end
  end
end