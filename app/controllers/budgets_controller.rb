# frozen_string_literal: true

class BudgetsController < ApplicationController
  before_action :budgets_facade, only: [:new]

  def new; end

  def create
    budget = budgets_facade.new_budget(allowed_params)

    if budget.save
      redirect_to budget, notice: t('.created')
    else
      render_error_messages_by_js
    end
  end

  def index
    if budgets_facade.first_user_budget
      redirect_to budgets_facade.first_user_budget
    else
      redirect_to new_budget_path
    end
  end

  def show
    authorize budgets_facade.budget
  end

  def edit
    authorize budgets_facade.budget
  end

  def update
    authorize budgets_facade.budget

    if budgets_facade.budget.update_attributes(allowed_params)
      redirect_to categories_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  def destroy
    authorize budgets_facade.budget

    if budgets_facade.budget.destroy
      redirect_to budgets_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  private

  def render_error_messages_by_js
    respond_to do |format|
      format.js { render partial: 'partials/flash', object: budget, as: 'resource' }
    end
  end

  def budget
    params[:id] ? set_budget : nil
  end

  def budgets_facade
    @budgets_facade ||= BudgetsFacade.new(current_user, budget)
  end

  def set_budget
    @_budget ||= Budget.find(params[:id])
  end

  def allowed_params
    params.require(:budget).permit(:date)
  end
end
