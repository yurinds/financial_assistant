# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :user
  has_many :operations

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 20 }

  before_destroy :check_for_dependent_operations

  scope :by_user, ->(user) { where(user: user) }

  def check_for_dependent_operations
    return true if Operation.count_by_category(self) == 0

    errors[:base] << I18n.t('.category.category_dependencies_error')
    throw :abort
  end

  def to_s
    name
  end
end
