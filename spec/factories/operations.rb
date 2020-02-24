# frozen_string_literal: true

FactoryBot.define do
  factory :operation do
    budget
    payment_method
    date { budget.date_from }
    amount { 1000 }
    description { Faker::Name.name_with_middle }

    factory :operation_with_income do
      association :category, factory: :category_income
      operation_type { category.operation_type }
    end

    factory :operation_with_expense do
      association :category, factory: :category_expense
      operation_type { category.operation_type }
    end
  end
end
