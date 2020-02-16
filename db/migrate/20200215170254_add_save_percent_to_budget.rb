# frozen_string_literal: true

class AddSavePercentToBudget < ActiveRecord::Migration[5.2]
  def change
    add_column :budgets, :save_percent, :integer, default: 0
  end
end
