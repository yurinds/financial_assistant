# frozen_string_literal: true

class Operation < ApplicationRecord
  belongs_to :budget
  belongs_to :category

  validates :date, presence: true
  validates :operation_type, presence: true
  validates :amount, presence: true

  scope :all_by_budget, ->(budget) { where(budget: budget).order(:date) }
  scope :sum_by_type, ->(type) { where(operation_type: type).sum(:amount) }

  def type
    # Тип операции может быть :income или :expense
    I18n.t(".operation.#{operation_type}")
  end
end
