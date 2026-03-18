class Question < ApplicationRecord
  include Votable, Reportable

  def to_param
    url.presence || id.to_s
  end
  enum :status, { draft: 0, published: 1, unpublished: 2 }

  # callback
  before_update :check_if_editable?
  before_save   :create_url_slug, if: :status_changed?
  before_save   :handle_timestamps, if: :status_changed?
  before_save   :set_edited_at
  after_save_commit :notify_users
  after_save_commit :update_home_feed
  after_save_commit :deduct_user_credits

  # associations
  belongs_to :user

  has_many :topic_assignements, as: :topicable, dependent: :destroy
  has_many :topics, through: :topic_assignements

  has_many :answers,  dependent: :restrict_with_error
  has_many :comments, dependent: :restrict_with_error, as: :commentable
  has_many :votes,    dependent: :restrict_with_error, as: :votable

  has_many :credit_transactions, as: :source

  has_one_attached :pdf

  # validations
  validates :title, uniqueness: true, allow_blank: true
  validates :title, :content, presence: true, if: :published?
  validate  :atleast_1_credit_needed, on: :publish
  validate  :must_have_topics_if_published
  validate  :pdf_type

  # scopes
  scope :from_date, ->(from) { where(posted_at: from.to_date.beginning_of_day..) }
  scope :till_date, ->(to) { where(posted_at: ..to.to_date.end_of_day) }

  # scores and ratings
  def engagement_score
    (0.5 * answers.size + 0.3 * votes.size + 0.2 * comments.size)
  end

  def editable?
    answers.empty? && comments.empty? && votes.empty?
  end

  def entities_present
    entities = []
    entities << "answer(s)" if answers.present?
    entities << "comment(s)" if comments.present?
    entities << "vote(s)" if votes.present?
  end

  def notify_users
    return if draft? || edited_at

    users_to_notify = User.joins(:topics).where(topics: { id: topic_ids }).distinct

    NotifyUserOnQuestionPostedJob.perform_later(self, users_to_notify.to_a)
  end

  def update_home_feed
    return if draft? || edited_at

    broadcast_update_to(
    "questions_feed",
    target: "new_questions_banner",
    partial: "questions/new_question_banner"
  )
  end

  private def check_if_editable?
    return if editable?

    errors.add(:base, "Question can not be edited if answers/comments/votes are present")
    throw(:abort)
  end

  private def atleast_1_credit_needed
    return if draft?
    if user.credits < 1
      errors.add(:user, "must have atleast 1 credit to ask a question.")
    end
  end

  private def must_have_topics_if_published
    if published? && topics.blank?
      errors.add(:topics, "must be selected when question is published.")
    end
  end

  private def pdf_type
    if pdf.attached? && pdf.filename.extension != "pdf"
      errors.add(:base, "Attachment must be a PDF file")
    end
  end

  private def create_url_slug
    if draft?
      self.url = nil
      return
    end

    base_url = title.parameterize
    slug = base_url
    suffix = 2

    while Question.exists?(url: base_url)
      base_url = "#{base_url}-#{suffix}"
      suffix += 1
    end

    self.url = base_url
  end

  private def handle_timestamps
    from, to = changes[:status]

    # draft -> published
    if [ from, to ] == [ "draft", "published" ]
      self.posted_at ||= Time.current
    end

    self.edited_at = nil
  end

  private def set_edited_at
    return unless published?
    return if status_changed?

    if will_save_change_to_title? || will_save_change_to_content?
      self.edited_at = Time.current
    end
  end

  private def deduct_user_credits
    return unless saved_change_to_status?

    from, to = saved_change_to_status
    return unless (from == "draft" || from == "unpublished") && to == "published"

    Question.transaction do
      user.decrement!(:credits)
      credit_transactions.create!(
        user: user,
        reason: "Question asked",
        type: :spent,
        units: 1
      )
    end
  end
end
