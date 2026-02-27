class Admin::TopicsController < Admin::BaseController
  before_action :set_topic, only: %i[ destroy ]

  def index
    scope = Topic.includes(:users, questions: [ :answers, :comments, :votes ])
    @topics = scope.order(created_at: :desc)
    @most_engaging_topic = scope.max_by(&:engagement_score)
    @least_engaging_topic = scope.min_by(&:engagement_score)
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        flash.now[:notice] = "New topic added."
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @topic.destroy
        flash.now[:notice] = "Topic deleted."
        format.turbo_stream
      else
        flash.now[:alert] = @topic.errors.full_messages.to_sentence
        format.turbo_stream
      end
    end
  end

  private def topic_params
    params.require(:topic).permit(:name)
  end

  private def set_topic
    @topic = Topic.find_by(id: params[:id])
  end
end
