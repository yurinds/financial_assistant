# frozen_string_literal: true

class OperationsCreator
  attr_reader :budget

  def initialize(operations: operations, budget: budget)
    @operations = operations
    @budget = budget
  end

  def perform
    Operation.create!(operations)
  end

  private

  def operations
    @operations.map do |item|
      item.merge(budget: budget)
    end
  end
end
