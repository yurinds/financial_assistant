# frozen_string_literal: true

FactoryBot.define do
  factory :payment_method do
    user
    name { Faker::Name.last_name }
  end
end
