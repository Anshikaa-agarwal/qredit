class CreditTransaction < ApplicationRecord
    # enum
    enum :type, { spent: 0, earnt: 1, purchased: 2 }

    # associations
    belongs_to :user
end
