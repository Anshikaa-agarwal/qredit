class Abuse < ApplicationRecord
    # associations
    belongs_to :user, foreign_key: :reporter_id
    belongs_to :reportable, polymorphic: true

    # validations
    validates :reason, presence: true
end
