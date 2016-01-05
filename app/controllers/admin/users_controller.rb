class Admin::UsersController < Admin::AdminController
  before_action :set_user, only: [:block, :unblock, :show, :edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit
  end

  def update
    redirect_to admin_users_path and return if @user == current_user
    if @user.update(user_attributes)
      redirect_to admin_users_path, notice: 'User has ben successfuly updated'
    else
      redirect_to admin_users_path, alert: 'Cannot update the user'
    end
  end

  def show
  end

  def block
    if @user.block && @user != current_user
      redirect_to admin_users_path, notice: 'User has been blocked'
    else
      redirect_to admin_users_path, alert: 'Cannot block a blocked user'
    end
  end

  def unblock
    if @user.unblock && @user != current_user
      redirect_to admin_users_path, notice: 'User has been unblocked'
    else
      redirect_to admin_users_path, alert: 'Cannot unblock a unblocked user'
    end
  end

  def search
    @users = User.search(params[:query]).paginate(page: params[:page])
    render :index
  end

  private

  def user_attributes
    params.require(:user).permit(:role)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
