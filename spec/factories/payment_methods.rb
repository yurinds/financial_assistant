# frozen_string_literal: true

FactoryBot.define do
  factory :payment_method do
    user
    name { Faker::Lorem.word }
  end
end
