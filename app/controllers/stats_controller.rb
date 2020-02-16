# frozen_string_literal: true

class StatsController < ApplicationController
  before_action :find_budgets_by_user, only: %i[index show]

  def index
    @current_budget = @budgets.first

    authorize @current_budget

    redirect_to budgets_path if @current_budget.nil?
    redirect_to stat_path @current_budget.id if @current_budget
  end

  def show
    @current_budget = Budget.find(params[:id])

    authorize @current_budget

    @daily_analytics = @current_budget.daily_analytics
    @categories = Operation.grouped_by_categories_amount(@current_budget)
    @payment_methods = Operation.grouped_by_payment_methods_amount(@current_budget)
  end

  private

  def find_budgets_by_user
    @budgets = Budget.all_by_user(current_user)
  end
end
