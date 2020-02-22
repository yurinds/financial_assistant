# frozen_string_literal: true

class StatsFacade
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def budgets
    @budgets ||= Budget.all_by_user(user)
  end

  def current_budget
    @current_budget ||= Budget.find(params[:id])
  end

  def first_user_budget
    @first_user_budget ||= budgets.first
  end

  def daily_analytics
    @daily_analytics ||= current_budget.daily_analytics
  end

  def categories
    @categories ||= Operation.grouped_by_categories_amount(current_budget)
  end

  def payment_methods
    @payment_methods ||= Operation.grouped_by_payment_method_amount(current_budget)
  end
end
