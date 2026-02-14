class Topic < ApplicationRecord
  # associations
  has_many :topic_assignements
  has_many :questions, through: :topic_assignements, source: :topicable, source_type: "Question"
  has_many :users,     through: :topic_assignements, source: :topicable, source_type: "User"

  # validations
  validates :name, presence: true, uniqueness: true
end
