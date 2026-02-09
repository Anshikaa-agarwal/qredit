class Abuse < ApplicationRecord
    # associations
    belongs_to :reporter, class_name: "User"
    belongs_to :reportable, polymorphic: true

    # validations
    validates :reason, presence: true
end
