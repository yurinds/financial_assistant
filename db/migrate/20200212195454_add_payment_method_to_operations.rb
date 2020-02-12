# frozen_string_literal: true

class AddPaymentMethodToOperations < ActiveRecord::Migration[5.2]
  def change
    add_reference :operations, :payment_method, foreign_key: true
  end
end
