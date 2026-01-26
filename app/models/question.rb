class Question < ApplicationRecord
    enum :status, { draft: 0, published: 1, unpublished: 2 }

    # associations
    belongs_to :user

    has_many :topic_assignements, as: :topicable
    has_many :topics, through: :topic_assignements

    has_many :answers,  dependent: :destroy
    has_many :comments, dependent: :destroy, as: :commentable
    has_many :votes,    dependent: :destroy, as: :votable

    has_many :abuse_reports, as: :reportable, dependent: :destroy

    has_one_attached :pdf
end
