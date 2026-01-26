class Vote < ApplicationRecord
    # enum
    enum :type, { upvote: 0, downvote: 1 }

    # associations
    belongs_to :user
    belongs_to :votable, polymorphic: true
end
