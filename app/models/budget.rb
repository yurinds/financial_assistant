# frozen_string_literal: true

class Budget < ApplicationRecord
  belongs_to :user
  has_many :operations

  validates :date_from, presence: true, uniqueness: { case_sensitive: false }
  validates :date_to, presence: true, uniqueness: { case_sensitive: false }

  before_validation :set_period

  scope :all_by_user, ->(current_user) { where(user: current_user).order(date_from: :desc).includes(:operations) }

  attr_accessor :date

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
    return if date.empty?

    new_date = save_parse_date

    return if new_date.nil?

    self.date_from = new_date.beginning_of_month
    self.date_to = new_date.end_of_month
  end

  def save_parse_date
    Date.parse(date)
  rescue ArgumentError
    nil
  end
end
