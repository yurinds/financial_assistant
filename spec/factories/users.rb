# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'example_user' }
    sequence(:email) { |n| "user_#{n}@example.com" }

    after(:build) { |u| u.password_confirmation = u.password = '123456' }
  end
end
