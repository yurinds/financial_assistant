# frozen_string_literal: true

FactoryBot.define do
  factory :operation do
    budget
    category
    payment_method
    operation_type { category.operation_type }
    date { budget.date_from }
    amount { rand(10_000) }
    description { Faker::Name.name_with_middle }
  end
end
