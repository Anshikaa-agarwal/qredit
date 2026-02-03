class Question < ApplicationRecord
    enum :status, { draft: 0, published: 1, unpublished: 2 }

    # callback
    before_update :check_if_editable?
    before_save   :create_url_slug, if: :status_changed?
    before_save   :deduct_user_credits
    before_save   :set_ever_published_flag, if: :published?

    # associations
    belongs_to :user

    has_many :topic_assignements, as: :topicable, dependent: :destroy
    has_many :topics, through: :topic_assignements

    has_many :answers,  dependent: :restrict_with_error
    has_many :comments, dependent: :restrict_with_error, as: :commentable
    has_many :votes,    dependent: :restrict_with_error, as: :votable

    has_many :credit_transactions, as: :source
    has_many :abuse_reports, class_name: "Abuse", as: :reportable, dependent: :destroy

    has_one_attached :pdf

    # validations
    validates :title, uniqueness: true, allow_blank: true
    validates :title, :content, presence: true, if: :published?
    validate  :atleast_1_credit_needed, on: :create
    validate  :must_have_topics_if_published
    validate  :pdf_type

    def posted_at_date
        created_at.to_date
    end

    def editable?
        !answers.exists? && !comments.exists? && !votes.exists?
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

    private def set_ever_published_flag
        return if draft? || ever_published?

        self.ever_published = true
    end

    private def deduct_user_credits
        return if draft? || ever_published?

        self.user.decrement!(:credits)

        # logs credit spent
        credit_transactions.create!(
            user: self.user,
            reason: "Question asked",
            status: :spent,
            units: 1
        )
    end
end
