class Question < ApplicationRecord
    enum :status, { draft: 0, published: 1, unpublished: 2 }

    # callback
    before_update :check_if_editable?

    # associations
    belongs_to :user

    has_many :topic_assignements, as: :topicable
    has_many :topics, through: :topic_assignements

    has_many :answers,  dependent: :restrict_with_error
    has_many :comments, dependent: :restrict_with_error, as: :commentable
    has_many :votes,    dependent: :restrict_with_error, as: :votable

    has_many :abuse_reports, as: :reportable, dependent: :destroy

    has_one_attached :pdf

    # validations
    validates :title, uniqueness: true, allow_blank: true
    validates :title, :content, presence: true, if: :published?
    validates :url, presence: true, uniqueness: true, if: :published?
    validate  :atleast_1_credit_needed, on: :create
    validate  :must_have_topics_if_published
    validate  :pdf_type

    private def check_if_editable
        return unless answers.exists? || comments.exists? || votes.exists?

        errors.add(:base, "Question can not be edited if answers/comments/votes are present")
        throw(:abort)
    end

    private def atleast_1_credit_needed
        if user.credits < 1
            errors.add(:user, "must have atleast 1 credit to ask a question.")
        end
    end

    private def must_have_topics_if_published
        return unless published?

        if topics.blank?
            errors.add(:topics, "must be selected when question is published.")
        end
    end

    private def pdf_type
        return unless pdf.attached?

        unless pdf.content_type == "application/pdf"
          errors.add(:pdf, "must be a PDF file")
        end
    end
end
