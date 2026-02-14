class Vote < ApplicationRecord
  self.inheritance_column = nil
  # enum
  enum :type, { upvote: 0, downvote: 1 }

  # associations
  belongs_to :user
  belongs_to :votable, polymorphic: true
end
