# frozen_string_literal: true

FactoryBot.define do
  factory :budget do
    user
    sequence(:date) { |n| (Date.current - n.month).to_s }
    sequence(:date_from) { |n| (Date.current - n.month).beginning_of_month }
    sequence(:date_to) { |n| (Date.current - n.month).end_of_month }
  end

  factory :budget_with_operations, parent: :budget do
    transient do
      operations_count { 5 }
    end

    after(:create) do |budget, evaluator|
      create_list(:operation_with_expense, evaluator.operations_count, budget: budget)
      create_list(:operation_with_income, evaluator.operations_count, budget: budget)
    end
  end

  factory :budget_with_expenses, parent: :budget do
    transient do
      operations_count { 5 }
    end

    after(:create) do |budget, evaluator|
      create_list(:operation_with_expense, evaluator.operations_count, budget: budget)
    end
  end

  factory :budget_with_incomes, parent: :budget do
    transient do
      operations_count { 5 }
    end

    after(:create) do |budget, evaluator|
      create_list(:operation_with_income, evaluator.operations_count, budget: budget)
    end
  end
end
