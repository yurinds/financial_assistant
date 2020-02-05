# frozen_string_literal: true

class BudgetsController < ApplicationController
  before_action :find_budgets_by_user, only: %i[index show]

  def new
    @new_budget = current_user.budgets.build
  end

  def create
    @budget = current_user.budgets.build(allowed_params)

    if @budget.save
      redirect_to @budget, notice: t('.created')
    else
      respond_to do |format|
        format.js { render :new }
      end
    end
  end

  def index
    @current_budget = @budgets.first

    if @current_budget
      redirect_to @current_budget
    else
      redirect_to new_budget_path
    end
  end

  def show
    @budget = Budget.find(params[:id])

    @operations = Operation.all_by_budget(@budget)
    @new_operation = @budget.operations.build
    @categories = Category.by_user(current_user)
  end

  private

  def find_budgets_by_user
    @budgets = Budget.all_by_user(current_user)
  end

  def allowed_params
    params.require(:budget).permit(:date)
  end
end
