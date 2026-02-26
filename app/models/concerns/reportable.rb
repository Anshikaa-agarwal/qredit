module Reportable
  extend ActiveSupport::Concern

  included do
    has_many :abuse_reports, class_name: "Abuse", as: :reportable, dependent: :destroy
    validate :abusive_content_can_not_be_republished, if: :status_changed?
  end

  def reported_by(user)
    return unless user
    abuse_reports.any? { |a| a.reporter_id == user.id }
  end

  def abuse_revert_credits
    credits_awarded = credit_transactions.earnt.sum(:units)
    if credits_awarded > 0
      User.transaction do
        user.decrement!(:credits, credits_awarded)

        user.credit_transactions.create!(
          reason: "#{self.class} marked abusive.",
          type: :spent,
          units: credits_awarded,
          source: self
        )
      end
    end
  end

  private def abusive_content_can_not_be_republished
    return unless will_save_change_to_status?
    return unless abusive?

    if status == "published"
      errors.add(:base, "Abusive content cannot be republished")
    end
  end
end
