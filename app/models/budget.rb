# frozen_string_literal: true

class Budget < ApplicationRecord
  belongs_to :user
  has_many :operations

  validates :date_from, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :date_to, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }

  before_validation :set_period

  before_destroy :check_for_dependent_operations

  scope :all_by_user, ->(current_user) { where(user: current_user).order(date_from: :desc).includes(:operations) }

  attr_accessor :date

  def operations_amount(type)
    operations ||= Operation.type_and_sum_by_budget(self)

    operations[type] || 0
  end

  def to_s
    "#{current_month} (#{current_year})"
  end

  def daily_analytics
    # структура: день => сумма_расхода
    daily_expenses = amount_of_expenses_for_each_day_of_the_month
    # сумма приходов
    budget_income = Operation.amount_of_income(self)

    # Доступная для расходов сумма
    save_amount = if save_percent == 0
                    budget_income
                  else
                    (((100 - save_percent.to_f) / 100) * budget_income)
                  end
    # количество дней в месяце
    count_days_in_month = date_to.end_of_month.day

    # сумма на каждый день
    amount_per_day = (save_amount / count_days_in_month)

    # массив, в котором будет накапливаться результат
    # Каждый элемент массива хэш с ключами: date, expenses, amount, balance
    result = []
    # При выполнении вычислений я умышленно допускаю погрешность
    # т.к. абсолютная точность не важна
    daily_expenses.keys.each_with_object([]) do |item, accum|
      # в массиве accum накапливается сальдо каждого дня.
      # Сальдо представляет собой накопленный итог сальдо за каждый день
      # Последний элемент массива - накопленное сальдо за все предыдущие дни.
      # Если массив пустой, то берётся 0.
      accumulated_amount_for_expenses = accum.last || 0

      # расходы за текущий день
      current_day_expences = daily_expenses[item]

      # доступная сумма расходов на текущий день
      current_day_amount = accumulated_amount_for_expenses + amount_per_day

      # сальдо на текущий день
      current_day_balance = current_day_amount - current_day_expences

      # добавляю сальдо текущего дня в массив
      accum << current_day_balance

      # добавляю информацию за день в массив
      result.push(date: item,
                  expenses: current_day_expences,
                  amount: current_day_amount.to_i,
                  balance: current_day_balance.to_i)

      # возвращаю массив с накопленным итогом
      accum
    end

    result
  end

  private

  def amount_of_expenses_for_each_day_of_the_month
    month_dates = list_month_days.each_with_object({}) do |date, new_hash|
      new_hash[date] = 0
    end
    daily_expenses = Operation.daily_expenses(self)

    month_dates.merge(daily_expenses)
  end

  def list_month_days
    [*date_from.beginning_of_month..date_from.end_of_month]
  end

  def check_for_dependent_operations
    return true if Operation.count_by_budget(self) == 0

    errors[:base] << I18n.t('.budget.dependencies_error')

    throw :abort
  end

  def set_period
    return if date_from

    return if date.empty?

    new_date = save_parse_date

    return if new_date.nil?

    self.date_from = new_date.beginning_of_month
    self.date_to = new_date.end_of_month
  end

  def current_month
    I18n.t("months.#{date_from.month}")
  end

  def current_year
    date_from.year
  end

  # Метод для безопасного создания даты.
  # По идее, здесь ему не место. Пока не
  # знаю куда его лучше перенести.
  def save_parse_date
    Date.parse(date)
  rescue ArgumentError
    nil
  end
end
