# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable #:confirmable

  has_many :budgets
  has_many :categories
  has_many :payment_methods

  validates :username, presence: true, length: { maximum: 35 }

  validates :email, presence: true, uniqueness: true
end
