# frozen_string_literal: true

class BudgetPolicy < ApplicationPolicy
  attr_reader :user, :budget

  def initialize(user, budget)
    @user = user
    @budget = budget
  end

  def show?
    user.budgets.find_by(id: budget.id)
  end

  alias destroy? show?
end
