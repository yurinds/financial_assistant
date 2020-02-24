# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    user
    name { Faker::Name.middle_name }

    factory :category_income do
      operation_type { 'income' }
    end
    factory :category_expense do
      operation_type { 'expense' }
    end
  end
end
