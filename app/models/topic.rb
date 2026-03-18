class Topic < ApplicationRecord
  # associations
  has_many :topic_assignements
  has_many :questions, through: :topic_assignements, source: :topicable, source_type: "Question", dependent: :restrict_with_error
  has_many :users,     through: :topic_assignements, source: :topicable, source_type: "User", dependent: :restrict_with_error

  # validations
  validates :name, presence: true, uniqueness: {  case_sensitive: false }

  # callbacks
  before_validation ->(topic) { topic.name = topic.name.capitalize }

  def engagement_score
    0.8 * (questions.sum(&:engagement_score)) + 0.2 * (users.size)
  end
end
