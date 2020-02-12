class CreatePaymentMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_methods do |t|
      t.text :name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
