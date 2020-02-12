# frozen_string_literal: true

class AddIsCashCheckBoxToPaymentMethods < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_methods, :is_cash, :boolean, default: false
  end
end
