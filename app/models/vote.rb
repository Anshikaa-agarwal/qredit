class Vote < ApplicationRecord
  self.inheritance_column = nil
  # enum
  enum :type, { upvote: 0, downvote: 1 }

  # associations
  belongs_to :user
  belongs_to :votable, polymorphic: true

  # validations
  validates :user_id, uniqueness: { scope: [ :votable_type, :votable_id ] }

  # callbacks
  after_commit :handle_answer_net_votes, if: -> { votable.is_a?(Answer) }

  private def handle_answer_net_votes
    votable.handle_vote_count
  end
end
