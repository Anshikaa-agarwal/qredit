class Admin::CommentsController < Admin::BaseController
  def index
    @comments = Comment.includes(:votes, :user).order(created_at: :desc)
    sort_by = params[:sort]
    from = params[:from]
    to = params[:to]

    @comments = @comments.reorder("created_at #{sort_by}") if sort_by.present?
    @comments = @comments.from_date(from) if from.present?
    @comments = @comments.till_date(to) if to.present?
  end

  def unpublish
    @comment = Comment.find_by(id: params[:id])
    @comment.status = :unpublished

    if @comment.save
      redirect_to admin_comments_path, notice: "Comment unpublished successfully."
    else
      redirect_to admin_comments_path, alert: "Could not unpublish comment."
    end
  end
end
