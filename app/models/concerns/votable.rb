module Votable
  extend ActiveSupport::Concern

  def vote_by(user)
    return unless user
    votes.find { |v| v.user_id == user.id }
  end

  def upvotes_count
    votes.select { |v| v.type == "upvote" }.size
  end
end
