class Admin::CategoriesController < Admin::AdminController
  before_action :set_category, only: [:edit, :show, :update, :destroy]

  def index
    @categories = Category.paginate(page: params[:page])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_attributes)
    if @category.save
      redirect_to admin_categories_path
      flash[:success] = "New category has beed added!"
    else
      render :new
    end
  end

  def edit
  end

  def show
  end

  def update
    if @category.update(category_attributes)
      redirect_to admin_categories_path
      flash[:success] = "Category has beed updated!"
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      redirect_to admin_categories_path
      flash[:success] = "Category has beed deleted!"
    else
      flash[:error] = "Category cannot be deleted!"
    end
  end

  def search
    @categories = Category.search(params[:query]).paginate(page: params[:page])
    render :index
  end

  private

  def category_attributes
    params.require(:category).permit(:name, :color)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
