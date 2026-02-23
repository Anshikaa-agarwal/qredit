module Votable
  extend ActiveSupport::Concern

  def vote_by(user)
    votes.find_by(user: user)
  end
end
