class Answer < ApplicationRecord
  # enum
  enum :status, { published: 0, unpublished: 1 }

  # associations
  belongs_to :user
  belongs_to :question

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes,    as: :votable,     dependent: :destroy

  has_many :credit_transactions, as: :source
  has_many :abuse_reports, class_name: "Abuse", as: :reportable, dependent: :destroy

  # validations
  validates :content, presence: true

  # callbacks
  after_create_commit :send_question_user_email

  def posted_at_date
    created_at.to_date
  end

  private def send_question_user_email
    UserMailer.with(user: question.user, question: question).answer_posted_email.deliver_now
  end
end
