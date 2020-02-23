# frozen_string_literal: true

FactoryBot.define do
  factory :budget do
    user
    sequence(:date_from) { |n| (Date.current - n.month).beginning_of_month }
    sequence(:date_to) { |n| (Date.current - n.month).end_of_month }
  end
end
