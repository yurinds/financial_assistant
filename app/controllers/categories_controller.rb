# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :find_category, except: %i[index new create]
  before_action :find_categories_by_user, only: %i[index create]
  before_action :build_category, only: %i[index new]

  def index; end

  def new
    respond_to do |format|
      format.js { render :form }
    end
  end

  def edit
    respond_to do |format|
      format.js { render :form }
    end
  end

  def create
    @category = current_user.categories.build(allowed_params)

    if @category.save
      redirect_to categories_path, notice: t('.success')
    else
      respond_to do |format|
        format.js { render :flash }
      end
    end
  end

  def update
    if @category.update_attributes(allowed_params)
      redirect_to categories_path, notice: t('.success')
    else
      respond_to do |format|
        format.js { render :flash }
      end
    end
  end

  def destroy
    if @category.destroy
      redirect_to categories_path, notice: t('.success')
    else
      respond_to do |format|
        format.js { render :flash }
      end
    end
  end

  private

  def find_categories_by_user
    @categories = Category.by_user(current_user)
  end

  def allowed_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find(params[:id])
  end

  def build_category
    @category = current_user.categories.build
  end
end
