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

  def posted_at_date
    created_at.to_date
  end
end
