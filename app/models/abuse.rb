class Abuse < ApplicationRecord
    # associations
    belongs_to :user, foreign_key: :reported_by_id
    belongs_to :reportable, polymorphic: true

    # validations
    validates :reason, presence: true
end
