# frozen_string_literal: true

class Budget < ApplicationRecord
  belongs_to :user
  has_many :operations

  validates :date_from, presence: true
  validates :date_to, presence: true

  before_validation :set_period

  scope :all_by_user, ->(current_user) { where(user: current_user).order(date_from: :desc).includes(:operations) }

  def current_month
    I18n.t("months.#{date_from.month}")
  end

  def current_year
    date_from.year
  end

  def operations_amount(type)
    operations = Operation.all_by_budget(self)
    operations.sum_by_type(type)
  end

  def to_s
    "#{current_month} (#{current_year})"
  end

  private

  def set_period
    return unless date_from

    current_date = date_from.dup

    self.date_from = current_date.beginning_of_month
    self.date_to = current_date.end_of_month
  end
end
