# frozen_string_literal: true

class CategoriesFacade
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def categories
    @categories ||= Category.by_user(user)
  end

  def category
    params[:id] ? set_category : new_category
  end

  def new_category(allowed_params = {})
    @new_category ||= user.categories.build(allowed_params)
  end

  private

  def set_category
    @category ||= Category.find(params[:id])
  end
end
