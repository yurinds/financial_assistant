# frozen_string_literal: true

class BudgetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @budgets = Budget.all_by_user(current_user)
    @current_budget = @budgets.first

    redirect_to @current_budget if @current_budget
  end

  def show
    @budget = Budget.find(params[:id])
    @budgets = Budget.all_by_user(current_user)

    @operations = Operation.all_by_budget(@budget)
    @new_operation = @budget.operations.build
    @categories = Category.by_user(current_user)
  end
end
