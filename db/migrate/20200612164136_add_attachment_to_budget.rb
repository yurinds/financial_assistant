class AddAttachmentToBudget < ActiveRecord::Migration[5.2]
  def change
    add_reference :budgets, :attachment, foreign_key: true
  end
end
