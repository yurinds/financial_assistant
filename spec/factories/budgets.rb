# frozen_string_literal: true

FactoryBot.define do
  factory :budget do
    user
    sequence(:date_from) { |n| (Date.current - n.month).beginning_of_month }
    sequence(:date_to) { |n| (Date.current - n.month).end_of_month }
  end

  factory :budget_with_operations, parent: :budget do
    transient do
      operations_count { 15 }
    end

    after(:create) do |budget, evaluator|
      create_list(:operation, evaluator.operations_count, budget: budget)
    end
  end
end
