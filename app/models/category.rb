# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :user
  has_many :operations

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 20 }

  def to_s
    name
  end
end
