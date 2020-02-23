# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    user
    name { Faker::Name.middle_name }
    operation_type { %w[income expense].sample }
  end
end
