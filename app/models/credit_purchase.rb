class CreditPurchase < ApplicationRecord
  # enum
  enum :status, { pending: 0, successful: 1, failed: 2 }

  # associations
  belongs_to :user
  has_many :credit_transactions, as: :source

  # validations
  validates :stripe_transaction_id, presence: true, uniqueness: true, if: :successful?
  validates :units, numericality: { only_integer: true, greater_than: 0 }
  validates :amount, numericality: { greater_than_or_equal_to: 0.01 }
end
