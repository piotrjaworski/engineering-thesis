class Admin::CategoriesController < ApplicationController
  before_action :check_admin
  before_action :set_category, only: [:edit, :update, :destroy, :show]
  layout :admin_assets

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_attributes)
    if @category.save
      redirect_to admin_dashboard_path
      flash[:success] = "New category has beed added!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update_attributes(category_attributes)
      redirect_to admin_dashboard_path
      flash[:success] = "Category has beed updated!"
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      redirect_to admin_dashboard_path
      flash[:success] = "Category has beed deleted!"
    else
      flash[:error] = "Category cannot be deleted!"
    end
  end

  def show
  end

  private

    def category_attributes
      params.require(:category).permit(:name, :postion)
    end

    def set_category
      @category = Category.find(params[:id])
    end

end
