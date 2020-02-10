# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable #:confirmable

  has_many :budgets
  has_many :categories

  validates :username, presence: true, length: { maximum: 35 }

  validates :email, presence: true
  validates :email, uniqueness: true
end
