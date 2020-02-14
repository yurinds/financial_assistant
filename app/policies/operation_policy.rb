# frozen_string_literal: true

class OperationPolicy < ApplicationPolicy
  attr_reader :user, :operation

  def initialize(user, operation)
    @user = user
    @operation = operation
  end

  def edit?
    budget_id = operation.budget_id
    user_budget = user.budgets.find_by(id: budget_id)

    return nil unless user_budget

    user_budget == operation.budget
  end

  alias update? edit?
  alias destroy? edit?
end
