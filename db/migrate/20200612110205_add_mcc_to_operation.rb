# frozen_string_literal: true

class AddMccToOperation < ActiveRecord::Migration[5.2]
  def change
    add_column :operations, :mcc, :string, limit: 4
  end
end
