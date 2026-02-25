class Abuse < ApplicationRecord
  ABUSE_THRESHOLD = 3

  # associations
  belongs_to :reporter, class_name: "User"
  belongs_to :reportable, polymorphic: true

  # callbacks
  after_create :check_and_unpublish

  # enum
  enum :reason, {
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

  private def check_and_unpublish
    if reportable.abuse_reports.count >= ABUSE_THRESHOLD
      reportable.status = :unpublished
    end
  end
end
