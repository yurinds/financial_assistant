# frozen_string_literal: true

class PaymentMethod < ApplicationRecord
  belongs_to :user
  has_many :operations

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }, length: { maximum: 20 }

  scope :by_user, ->(user) { where(user: user).order(:name) }

  before_destroy :check_for_dependent_operations

  def check_for_dependent_operations
    return true if Operation.count_by_payment_method(self) == 0

    errors[:base] << I18n.t('.payment_method.dependencies_error')
    throw :abort
  end

  def to_s
    name
  end

  def cash?
    is_cash
  end
end
