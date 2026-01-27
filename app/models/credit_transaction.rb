class CreditTransaction < ApplicationRecord
    # enum
    enum :type, { spent: 0, earnt: 1, purchased: 2 }

    # associations
    belongs_to :user

    # validations
    validates :amount, numericality: { greater_than_or_equal_to: 0.01 }
end
