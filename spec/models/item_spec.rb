require 'rails_helper'

RSpec.describe Item do

  describe 'relationships' do
    it { should belong_to :merchant}
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'class methods' do
    it '::not_yet_shipped' do
      shippable_items = Item.not_yet_shipped

      expect(shippable_items.size).to eq(135)
      expect(shippable_items.first.name).to eq("Item Hic Soluta")
      expect(shippable_items.last.name).to eq("Item Ratione Dolor")
    end
  end
end
