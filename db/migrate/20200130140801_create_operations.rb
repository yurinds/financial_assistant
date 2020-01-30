# frozen_string_literal: true

class CreateOperations < ActiveRecord::Migration[5.2]
  def change
    create_table :operations do |t|
      t.date :date
      t.string :operation_type
      t.string :description
      t.string :amount
      t.references :category, foreign_key: true
      t.references :budget, foreign_key: true

      t.timestamps
    end
  end
end
