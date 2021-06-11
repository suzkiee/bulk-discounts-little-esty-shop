require 'rails_helper'

RSpec.describe 'bulk discounts edit page', type: :feature do
  before(:each) do
    @merchant = create(:mock_merchant) 
    @new_discount = create(:mock_bulk_discount, merchant: @merchant)
    visit edit_merchant_bulk_discount_path(@merchant, @new_discount)
  end

  describe 'display' do
    it 'shows the current information for the record' do

      expect(page).to have_content("#{@new_discount.name}")
      expect(page).to have_content("#{@new_discount.percent_discount}")
      expect(page).to have_content("#{@new_discount.threshold}")
    end
  end

  describe 'page functionality' do
    it 'allows me to update the info, and redirects me to the show page with a success flash message' do

      fill_in 'Name', with: 'Ultra Special Youtube Discount'

      click_on 'Save changes'

      expect(current_path).to eq("/admin/merchants/#{new_merchant.id}")
      expect(page).to have_content('Ultra Special Youtube Discount')
      expect(page).to have_content('You have successfully updated this discount!')
    end
  end
end