# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.timestamps
      t.string :firstname, null: false
      t.string :lastname, null: false
    end
  end
end
