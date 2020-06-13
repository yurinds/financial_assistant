# frozen_string_literal: true

class OperationsFacade
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def categories
    @categories = Category.by_user(user)
  end

  def payment_methods
    @payment_methods ||= PaymentMethod.by_user(user)
  end

  def budget
    @budget ||= Budget.find(params[:budget_id])
  end

  def new_operation(allowed_params = {})
    @new_operation ||= budget.operations.build(allowed_params)
  end

  def operation
    params[:id] ? set_operation : new_operation
  end

  private

  def set_operation
    @operation ||= Operation.find(params[:id])
  end
end
