class Answer < ApplicationRecord
  include Votable, Reportable
  NETVOTE_THRESHOLD = 10

  # enum
  enum :status, { published: 0, unpublished: 1 }

  # associations
  belongs_to :user
  belongs_to :question

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes,    as: :votable,     dependent: :destroy

  has_many :credit_transactions, as: :source

  # validations
  validates :content, presence: true

  # callbacks
  # after_create_commit :send_question_user_email

  # scopes
  scope :from_date, ->(from) { where(created_at: from.to_date.beginning_of_day..) }
  scope :till_date, ->(to) { where(created_at: ..to.to_date.end_of_day) }

  def posted_at_date
    created_at.to_date
  end

  def handle_vote_count
    prev_net_votes = self.net_votes
    recalculate_net_votes!
    current_net_votes = net_votes

    if prev_net_votes < NETVOTE_THRESHOLD && current_net_votes >= NETVOTE_THRESHOLD
      award_credits
    elsif prev_net_votes >= NETVOTE_THRESHOLD && current_net_votes < NETVOTE_THRESHOLD
      revert_credits
    end
  end

  private def send_question_user_email
    UserMailer.with(user: question.user, question: question).answer_posted_email.deliver_now
  end

  private def recalculate_net_votes!
    net_votes = votes.upvote.count - votes.downvote.count
    update(net_votes: net_votes)
  end

  private def award_credits
    User.transaction do
      user.increment!(:credits)

      user.credit_transactions.create!(
        reason: "Answer reached #{NETVOTE_THRESHOLD} net votes.",
        type: :earnt,
        units: 1,
        source: self
      )
    end
  end

  private def revert_credits
    User.transaction do
      user.decrement!(:credits)

      user.credit_transactions.create!(
        reason: "Credit reverted: net votes falled below #{NETVOTE_THRESHOLD}",
        type: :spent,
        units: 1
      )
    end
  end
end
