# app/models/invoice_items

class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :bulk_discounts, through: :item
  # enum status: { pending: 0, packaged: 1, shipped: 2 }
  enum status: [:pending, :packaged, :shipped]

  def self.total_revenue
    sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def find_discount
    bulk_discounts.where("bulk_discounts.threshold <= ?", quantity)
                  .order(percent_discount: :desc).first
  end
end
