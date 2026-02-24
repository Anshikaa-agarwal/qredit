class Abuse < ApplicationRecord
  # associations
  belongs_to :reporter, class_name: "User"
  belongs_to :reportable, polymorphic: true

  # enum
  enum reason: {
    spam: 0,
    fraud_or_scam: 1,
    harassment: 2,
    hate_speech: 3,
    impersonation: 4,
    inappropriate_content: 5,
    misinformation: 6,
    illegal_activity: 7
  }

  # validations
  validates :reason, presence: true
  validates :reporter_id, uniqueness: { scope: [ :reportable_type, :reportable_id ],
    message: "already reported this content" }
end
