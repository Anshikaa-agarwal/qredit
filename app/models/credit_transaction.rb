class CreditTransaction < ApplicationRecord
  self.inheritance_column = nil

  # enum
  enum :type, { spent: 0, earnt: 1 }

  # associations
  belongs_to :user
  belongs_to :source, polymorphic: true, optional: true

  # validations
  validates :units, numericality: { only_integer: true, greater_than: 0 }
end
