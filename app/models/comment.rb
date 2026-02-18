class Comment < ApplicationRecord
  include Votable

  # associations
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  # validations
  validates :content, presence: true

  def vote_by(user)
    votes.find_by(user: user)
  end
end
