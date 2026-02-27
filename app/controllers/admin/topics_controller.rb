class Admin::TopicsController < Admin::BaseController
  before_action :set_topic, only: %i[ edit update destroy ]

  def index
    @topics = Topic.includes(:questions, :users).all
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
        flash.now[:alert] = "Could not add topic."
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private def topic_params
    params.require(:topic).permit(:name)
  end

  private def set_topic
    @topic = Topic.find_by(id: params[:id])
  end
end
