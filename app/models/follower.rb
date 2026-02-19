class Follower < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  # validations
  validate :can_not_follow_yourself

  def can_not_follow_yourself
    return if followee_id != follower_id

    errors.add(:base, "User can not follow themselves")
    throw :abort
  end
end
