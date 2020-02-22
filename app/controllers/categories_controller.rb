# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :categories_facade, only: %i[index new]

  def index; end

  def new
    respond_to do |format|
      format.js { render :form }
    end
  end

  def edit
    authorize categories_facade.category

    respond_to do |format|
      format.js { render :form }
    end
  end

  def create
    category = categories_facade.new_category(allowed_params)

    if category.save
      redirect_to categories_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  def update
    authorize categories_facade.category

    if categories_facade.category.update_attributes(allowed_params)
      redirect_to categories_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  def destroy
    authorize categories_facade.category

    if categories_facade.category.destroy
      redirect_to categories_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  private

  def categories_facade
    @categories_facade ||= CategoriesFacade.new(current_user, params)
  end

  def render_error_messages_by_js
    respond_to do |format|
      format.js { render partial: 'partials/flash', object: categories_facade.category, as: 'resource' }
    end
  end

  def allowed_params
    params.require(:category).permit(:name, :operation_type)
  end
end
