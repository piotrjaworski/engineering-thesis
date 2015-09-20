class Admin::CategoriesController < Admin::AdminController
  expose(:category, attributes: :category_attributes)

  def new
  end

  def create
    if category.save
      redirect_to admin_dashboard_path
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
    if category.update_attributes(category_attributes)
      redirect_to admin_dashboard_path
      flash[:success] = "Category has beed updated!"
    else
      render :edit
    end
  end

  def destroy
    if category.destroy
      redirect_to admin_dashboard_path
      flash[:success] = "Category has beed deleted!"
    else
      flash[:error] = "Category cannot be deleted!"
    end
  end

  private

    def category_attributes
      params.require(:category).permit(:name, :color)
    end

end
