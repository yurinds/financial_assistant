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

  def current_month
    I18n.t("months.#{date_from.month}")
  end

  def current_year
    date_from.year
  end

  def operations_amount(type)
    operations ||= Operation.type_and_sum_by_budget(self)

    operations[type]
  end

  def to_s
    "#{current_month} (#{current_year})"
  end

  private

  def check_for_dependent_operations
    return true if Operation.count_by_budget(self) == 0

    errors[:base] << I18n.t('.budget.dependencies_error')

    throw :abort
  end

  def set_period
    return if date.empty?

    new_date = save_parse_date

    return if new_date.nil?

    self.date_from = new_date.beginning_of_month
    self.date_to = new_date.end_of_month
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
