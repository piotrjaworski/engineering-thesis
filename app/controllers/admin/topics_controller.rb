class Admin::TopicsController < Admin::AdminController
  before_action :set_topic, except: [:index, :search]

  def index
    @topics = Topic.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @topic.update(topic_attributes)
      redirect_to admin_topics_path, notice: "Topic has been updated"
    else
      redirect_to admin_topics_path, alert: "Cannot update topic"
    end
  end

  def close
    if @topic.close
      redirect_to admin_topics_path, notice: "Topic has been closed"
    else
      redirect_to admin_topics_path, alert: "Cannot close a closed topic"
    end
  end

  def open
    if @topic.open
      redirect_to admin_topics_path, notice: "Topic has been opend"
    else
      redirect_to admin_topics_path, alert: "Cannot open a closed topic"
    end
  end

  def search
    @topics = Topic.search(params[:query]).paginate(page: params[:page])
    render :index
  end

  private

  def topic_attributes
    params.require(:topic).permit(:name, :description, :category_id)
  end

  def set_topic
    params[:id] ||= params[:topic_id]
    @topic = Topic.find(params[:id])
  end
end
