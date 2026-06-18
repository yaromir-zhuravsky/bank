# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.timestamps
      t.bigint :user_id, null: false
      t.bigint :balance, null: false, default: 0
      t.string :number, null: false
      t.string :currency, null: false
    end

    add_check_constraint :accounts,
                         "number ~ '^[0-9]{16}$'",
                         name: "chk_accounts_number_numerical"
    add_foreign_key :accounts, :users
    add_index :accounts, :number, unique: true
  end
end
