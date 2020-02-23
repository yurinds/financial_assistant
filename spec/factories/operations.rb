# frozen_string_literal: true

FactoryBot.define do
  factory :operation do
    budget
    category
    payment_method
    operation_type { category.operation_type }
    date { budget.date_from }
    amount { rand(10_000) }
    username { Faker::Name.name }
    description { Faker::Lorem.sentence(word_count: 5) }
  end
end
