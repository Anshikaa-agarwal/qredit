class Vote < ApplicationRecord
    # enum
    enum :kind, { upvote: 0, downvote: 1 }

    # associations
    belongs_to :user
    belongs_to :votable, polymorphic: true
end
