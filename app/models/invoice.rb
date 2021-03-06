# app/models/invoice

class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [ 'in progress', :completed, :cancelled ] # 0 => in progress, 1 => completed, etc 

  def self.filter_by_unshipped_order_by_age
    joins(:invoice_items)
    .distinct.select("invoices.id, invoices.created_at")
    .where.not(invoice_items: {status: 'shipped'})
    .order(:created_at)
  end

  def statuses
    ['in progress', 'completed', 'cancelled']
  end

  # Utilizes class method from InvoiceItems
  def revenue
    invoice_items.total_revenue
  end

  def total_discount
    invoice_items.joins(:bulk_discounts)
                 .select("invoice_items.id, max(invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.percent_discount / 100.00)) as total_discount")
                 .where("invoice_items.quantity >= bulk_discounts.threshold")
                 .group("invoice_items.id")
                 .order("total_discount desc")
                 .sum(&:"total_discount")
  end
end
