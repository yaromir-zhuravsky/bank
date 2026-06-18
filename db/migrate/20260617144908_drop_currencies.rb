# frozen_string_literal: true

class DropCurrencies < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :accounts, :currencies

    drop_table :currencies
  end
end
