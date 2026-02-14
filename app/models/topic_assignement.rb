class TopicAssignement < ApplicationRecord
  # associations
  belongs_to :topic
  belongs_to :topicable, polymorphic: true
end
