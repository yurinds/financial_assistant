# frozen_string_literal: true

class Operation < ApplicationRecord
  belongs_to :budget
  belongs_to :category
  belongs_to :payment_method, optional: true

  validates :date, presence: true
  validates :operation_type, presence: true
  validates :amount, presence: true

  validate :operation_date_should_correspond_to_budget_period

  enum operation_type: %i[expense income]

  scope :all_by_budget, ->(budget) { where(budget: budget).includes(:category, :payment_method).order(date: :desc).order('categories.name') }
  scope :count_by_budget, ->(budget) { where(budget: budget).count }
  scope :count_by_category, ->(category) { where(category: category).count }
  scope :count_by_payment_method, ->(payment_method) { where(payment_method: payment_method).count }
  scope :sum_by_type, ->(type) { where(operation_type: type).sum(:amount) }
  scope :type_and_sum_by_budget, (lambda do |budget|
    where(budget: budget)
      .select(:operation_type, :amount)
      .group(:operation_type)
      .sum(:amount)
  end)
  scope :daily_expenses, (lambda do |budget|
    where(budget: budget)
      .where(operation_type: :expense)
      .select(:date, :amount)
      .group(:date)
      .sum(:amount)
  end)
  scope :amount_of_income, ->(budget) { where(budget: budget).where(operation_type: :income).sum(:amount) }
  scope :grouped_by_categories_amount, (lambda { |budget|
                                          select(:category, :amount)
                                            .where(budget: budget)
                                            .group(:category)
                                            .sum(:amount)
                                            .sort_by(&:last)
                                            .to_h
                                        })

  before_validation :set_category_by_mcc, if: :mcc_defined?
  before_validation :set_operation_type!

  Payment = Struct.new(:payment_method, :operation_type, :amount) do
    def expense?
      operation_type == 'expense'
    end

    def income?
      operation_type == 'income'
    end
  end

  def self.grouped_by_payment_method_amount(budget)
    relation = select(:payment_method_id, :operation_type, :amount)
               .where(budget: budget)
               .group(:payment_method_id, :operation_type)
               .sum(:amount)
               .sort_by(&:last)
               .to_h

    payment_method_ids = relation.keys.map(&:first).reject(&:nil?)
    payment_methods = PaymentMethod.find(payment_method_ids)

    pay_method_to_relation = payment_methods.map { |item| [item.id, item] }.to_h

    relation.each_with_object([]) do |(key, value), acc|
      payment_method = pay_method_to_relation[key.first]
      type = key.last
      amount = value

      acc << Payment.new(payment_method, type, amount)
      acc
    end
  end

  def type
    # Тип операции может быть :income или :expense
    I18n.t(".operation.#{operation_type}")
  end

  def operation_date_should_correspond_to_budget_period
    return unless budget

    budget_period = (budget.date_from..budget.date_to)

    return if budget_period.include?(date)

    errors.add(:date, I18n.t('.period_error'))
  end

  def set_operation_type!
    return unless category

    self.operation_type = category.operation_type
  end

  def set_category_by_mcc
    category_name = Settings.mcc[mcc]

    if category_name.nil?
      errors.add(:mcc, :mcc_undefined)
      return
    end

    category = Category.find_or_create_by(user: budget.user, name: category_name) do |item|
      item.operation_type = 'expense'
    end

    self.category = category
  end

  def self.update_all_or_create(attributes)
    attributes.each do |item|
      operation = find_or_create_by(item)
      operation.update!(item)
    end
  end

  def mcc_defined?
    !mcc.nil? && !mcc.empty?
  end
end
