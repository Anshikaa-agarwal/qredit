class CreditPurchase < ApplicationRecord
    # enum
    enum :type, { pending: 0, successful: 1, failed: 2 }

    # associations
    belongs_to :user
end
