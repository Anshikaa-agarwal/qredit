class Comment < ApplicationRecord
  include Votable, Reportable

  # enum
  enum :status, { published: 0, unpublished: 1 }

  # associations
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many   :votes, as: :votable

  # validations
  validates :content, presence: true

  # scopes
  scope :from_date, ->(from) { where(posted_at: from.to_date.beginning_of_day..) }
  scope :till_date, ->(to) { where(posted_at: ..to.to_date.end_of_day) }

  def posted_at_date
    created_at.to_date
  end
end
