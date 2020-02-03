# frozen_string_literal: true

class BudgetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @budgets = Budget.all_by_user(current_user)
    @current_budget = @budgets.first || current_user.budgets.build
    @operations = Operation.all_by_budget(@current_budget)
    @new_operation = @current_budget.operations.build
    @categories = Category.by_user(current_user)
  end
end
