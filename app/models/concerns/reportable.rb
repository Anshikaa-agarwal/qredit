module Reportable
  extend ActiveSupport::Concern

  included do
    has_many :abuse_reports, class_name: "Abuse", as: :reportable, dependent: :destroy
  end

  def reported_by(user)
    return unless user
    abuse_reports.any? { |a| a.reporter_id == user.id }
  end
end
