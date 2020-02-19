# frozen_string_literal: true

class ChangeColumnOperationTypeInCategories < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :categories do |t|
        query_up = <<~SQL
          integer USING CAST(CASE operation_type
                                 WHEN 'expense' THEN 0
                                 WHEN 'income' THEN 1
                             END AS integer)
        SQL

        query_down = <<~SQL
          text USING CAST(CASE operation_type
                                 WHEN 0  THEN 'expense'
                                 WHEN 1 THEN 'income'
                             END AS text)
        SQL

        dir.up   { t.change :operation_type, query_up }
        dir.down { t.change :operation_type, query_down }
      end
    end
  end
end
