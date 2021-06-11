require 'rails_helper'

RSpec.describe 'create bulk discount' do
  before :each do 
    @merchant = create(:mock_merchant)
  end

  it 'creates a new bulk discount' do
    visit merchant_bulk_discounts_path(@merchant)

    click_on('Create New Bulk Discount')

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
    
    fill_in 'Name', with: 'Special Youtube Discount'
    fill_in 'Percent discount', with: 30
    fill_in 'Threshold', with: 10
    click_on 'Create Bulk discount'

    expect(current_path).to eq merchant_bulk_discounts_path(@merchant)
    expect(page).to have_content('Special Youtube Discount')
  end
end

