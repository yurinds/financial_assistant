# frozen_string_literal: true

class Operation < ApplicationRecord
  belongs_to :budget
  belongs_to :category

  validates :date, presence: true
  validates :operation_type, presence: true
  validates :amount, presence: true

  validate :operation_date_should_correspond_to_budget_period

  scope :all_by_budget, ->(budget) { where(budget: budget).includes(:category).order(:date) }
  scope :count_by_budget, ->(budget) { where(budget: budget).count }
  scope :sum_by_type, ->(type) { where(operation_type: type).sum(:amount) }
  scope :count_by_category, ->(category) { where(category: category).count }
  scope :type_and_sum_by_budget, lambda { |budget|
                                   where(budget: budget)
                                     .select(:operation_type, :amount)
                                     .group(:operation_type)
                                     .sum(:amount)
                                 }

  before_validation :set_operation_type!

  def type
    # Тип операции может быть :income или :expense
    I18n.t(".operation.#{operation_type}")
  end

  def operation_date_should_correspond_to_budget_period
    budget_period = (budget.date_from..budget.date_to)

    return if budget_period.include?(date)

    errors.add(:date, I18n.t('.period_error'))
  end

  def set_operation_type!
    self.operation_type = category.operation_type
  end
end
