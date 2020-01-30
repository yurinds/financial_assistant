# frozen_string_literal: true

class Operation < ApplicationRecord
  belongs_to :budget
  belongs_to :category

  # :income :expense
end
