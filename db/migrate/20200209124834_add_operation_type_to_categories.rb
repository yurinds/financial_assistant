# frozen_string_literal: true

class AddOperationTypeToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :operation_type, :string
  end
end
