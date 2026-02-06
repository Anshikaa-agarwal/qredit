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

  # callbacks
  after_commit :send_question_user_email

  def net_votes
    votes.upvote.count - votes.downvote.count
  end

  def posted_at_date
    created_at.to_date
  end

  private def send_question_user_email
    UserMailer.with(user: question.user, question: question).answer_posted_email.deliver_now
  end
end
