# frozen_string_literal: true

class AddAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.references :budget, foreign_key: true
      t.string :path

      t.timestamps
    end
  end
end
