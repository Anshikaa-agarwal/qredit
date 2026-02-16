module VotesHelper
  def vote_path_for(votable, vote = nil)
    elements = []

    case votable
    when Question
      elements << votable
    when Answer
      elements << votable.question
      elements << votable
    when Comment
      if votable.commentable.is_a?(Question)
        elements << votable.commentable
      elsif votable.commentable.is_a?(Answer)
        elements << votable.commentable.question
        elements << votable.commentable
      end
      elements << votable
    end

    vote ? elements << vote : elements << :votes # to delete
  end
end
