class CreateBudgets < ActiveRecord::Migration[5.2]
  def change
    create_table :budgets do |t|
      t.references :user, foreign_key: true
      t.date :date_from
      t.date :date_to

      t.timestamps
    end
  end
end
