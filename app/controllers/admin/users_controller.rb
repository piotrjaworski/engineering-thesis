class Admin::UsersController < Admin::AdminController
  before_filter :set_user, only: [:block, :unblock, :show]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  end

  def block
    if @user.block && @user != current_user
      redirect_to admin_users_path, notice: "User has been blocked"
    else
      redirect_to admin_users_path, alert: "Cannot block a blocked user"
    end
  end

  def unblock
    if @user.unblock && @user != current_user
      redirect_to admin_users_path, notice: "User has been unblocked"
    else
      redirect_to admin_users_path, alert: "Cannot unblock a unblocked user"
    end
  end

  def search
    @users = User.search(params[:query]).paginate(page: params[:page])
    render :index
  end

  private

  def set_user
    params[:id] ||= params[:user_id]
    @user = User.find(params[:id])
  end

end
