class UsersController < ApplicationController
  before_action :authenticate_user!, only: [ :update_profile, :credits ]
  before_action :set_current_user, only: [ :update_profile ]
  before_action :set_user, only: [ :show, :update_profile ]

  def show
    load_remaining_topics if viewing_own_profile?
  end

  def update_profile
    if params[:remove_avatar]
      @current_user.avatar.destroy
    end

    if params[:user]&.[](:avatar)
      unless @current_user.update(user_avatar_params)
        @user = current_user
        load_remaining_topics if viewing_own_profile?
        flash.now[:alert] = @current_user.errors.full_messages.to_sentence
        render :show, status: :unprocessable_entity
        return
      end
    end

    redirect_to user_path(@current_user)
  end

  def credits
    @credit_count = current_user.credits
    @transactions = current_user.credit_transactions.includes(:source)
  end

  def followers
    @user = User.find_by(username: params[:user_username])
    if @user
      @followers = @user.followers.includes(avatar_attachment: :blob)
      @followees = @user.followees.includes(avatar_attachment: :blob)
    else
      redirect_back fallback_location: root_path, alert: "User not found."
    end
  end

  def report
    @user = current_user
    # topic user asked most questions on
    @most_asked_topic = @user.questions.joins(:topics).group("topics.id", "topics.name").count.max_by { |_, count| count }

    # question with no answers even after a day
    @no_answers_after_a_day = @user.questions.left_joins(:answers).where(questions: { posted_at: ..1.day.ago }).where(answers: { id: nil })
    # @user.questions.where(posted_at: ..1.day.ago).where.missing(:answers)

    # user who upvotes your content the most
    content_ids = @user.question_ids +  @user.answer_ids +  @user.comment_ids
    @most_interactive_user = Vote.where(votes: { type: :upvote, votable_id: content_ids }).group("votes.user_id").count.max_by { |_, count| count }

    # questions with 0 engagement (0 answers + 0 comments + 0 votes)
    @no_engagement_questions = @user.questions.published.where.missing(:answers, :comments, :votes)

    # Among questions asked by people the user follows, find the most common topic.
    @most_common_folloewers_topic = @user.followees.joins(questions: :topics).where(questions: { status: :published }).group("topics.id", "topics.name").count.max_by { |_, count| count }
  end

  def active_for_authentication?
    super && !disabled?
  end

  private

  def set_user
    @user = User.includes(:topics, :topic_assignements, avatar_attachment: :blob).find_by(username: params[:username])
    unless @user
      redirect_back fallback_location: root_path, alert: "User not found."
    end
  end

  def set_current_user
    @current_user = current_user

    unless @current_user
      redirect_back fallback_location: root_path, alert: "User not logged in."
    end
  end

  def user_avatar_params
    params.require(:user).permit(:avatar)
  end

  def viewing_own_profile?
    user_signed_in? && @user == current_user
  end

  def load_remaining_topics
    @remaining_topics = Topic.where.not(id: @user.topics.select(:id))
  end
end
