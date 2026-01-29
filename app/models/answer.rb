class Answer < ApplicationRecord
    # enum
    enum :status, { draft: 0, published: 1, unpublished: 2 }

    # associations
    belongs_to :user
    belongs_to :question

    has_many :comments, as: :commentable, dependent: :destroy
    has_many :votes,    as: :votable,     dependent: :destroy

    has_many :credit_transactions, as: :source
    has_many :abuse_reports, as: :reportable, dependent: :destroy

    # validations
    validates :content, presence: true
end
