# frozen_string_literal: true

class BudgetsFacade
  attr_reader :user, :budget

  def initialize(user, budget)
    @user = user
    @budget = budget
  end

  def new_budget(allowed_params = {})
    @new_budget ||= user.budgets.build(allowed_params)
  end

  def budgets
    @budgets ||= Budget.all_by_user(user)
  end

  def first_user_budget
    @first_user_budget ||= budgets.first
  end

  def operations
    @operations ||= Operation.all_by_budget(budget)
  end

  def operation
    @operation ||= budget.operations.build
  end

  def categories
    @categories ||= Category.by_user(user)
  end

  def payment_methods
    @payment_methods ||= PaymentMethod.by_user(user)
  end
end
