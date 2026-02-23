class Comment < ApplicationRecord
  include Votable

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
