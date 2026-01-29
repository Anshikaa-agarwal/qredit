class CreditTransaction < ApplicationRecord
    # enum
    enum :status, { spent: 0, earnt: 1 }

    # associations
    belongs_to :user
    belongs_to :source, polymorphic: true, optional: true

    # validations
    validates :units, numericality: { greater_than_or_equal_to: 0.01 }
end
