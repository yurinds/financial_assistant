# frozen_string_literal: true

class BudgetsController < ApplicationController
  before_action :find_budgets_by_user, only: %i[index show]
  before_action :find_budget, only: %i[edit update destroy show]

  def new
    @new_budget = current_user.budgets.build
  end

  def create
    @budget = current_user.budgets.build(allowed_params)

    if @budget.save
      redirect_to @budget, notice: t('.created')
    else
      render_error_messages_by_js
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
    authorize @budget

    @operations = Operation.all_by_budget(@budget)
    @operation = @budget.operations.build
    @categories = Category.by_user(current_user)
    @payment_methods = PaymentMethod.by_user(current_user)
  end

  def edit
    authorize @budget
  end

  def update
    authorize @budget

    if @budget.update_attributes(allowed_params)
      redirect_to categories_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  def destroy
    authorize @budget

    if @budget.destroy
      redirect_to budgets_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  private

  def render_error_messages_by_js
    respond_to do |format|
      format.js { render partial: 'partials/flash', object: @budget, as: 'resource' }
    end
  end

  def find_budgets_by_user
    @budgets = Budget.all_by_user(current_user)
  end

  def find_budget
    @budget = Budget.find(params[:id])
  end

  def allowed_params
    params.require(:budget).permit(:date)
  end
end
