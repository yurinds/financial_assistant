class Budget < ApplicationRecord
  belongs_to :user
  has_many :operations
end
