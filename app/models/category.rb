# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :user
  has_many :operations

  enum operation_type: %i[expense income]

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }, length: { maximum: 50 }
  validates :operation_type, presence: true

  before_destroy :check_for_dependent_operations

  scope :by_user, ->(user) { where(user: user).order(:name) }

  def check_for_dependent_operations
    return true if Operation.count_by_category(self) == 0

    errors[:base] << I18n.t('.category.dependencies_error')
    throw :abort
  end

  def to_s
    name
  end
end
