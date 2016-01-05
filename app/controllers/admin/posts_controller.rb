class Admin::PostsController < Admin::AdminController
  before_action :set_post, only: [:edit, :update, :show]

  def index
    @posts = Post.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @post.update(post_attributes)
      redirect_to admin_posts_path, notice: 'Post has been updated'
    else
      redirect_to admin_posts_path, alert: 'Post cannot been updated'
    end
  end

  def show
  end

  def destroy
    @post.who_deletes = current_user
    if @post.destroy
      redirect_to admin_posts_path, sucess: 'Post has been successfuly removed'
    else
      redirect_to admin_posts_path, alert: 'Cannot destroy the post'
    end
  end

  def search
    @posts = Post.search(params[:query]).paginate(page: params[:page])
    render :index
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_attributes
    params.require(:post).permit(:content)
  end
end
