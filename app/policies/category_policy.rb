# frozen_string_literal: true

class CategoryPolicy < ApplicationPolicy
  attr_reader :user, :category

  def initialize(user, category)
    @user = user
    @category = category
  end

  def edit?
    user.categories.find_by(id: category.id)
  end

  alias update? edit?
  alias destroy? edit?
end
