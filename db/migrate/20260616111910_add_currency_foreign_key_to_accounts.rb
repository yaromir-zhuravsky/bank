# frozen_string_literal: true

class AddCurrencyForeignKeyToAccounts < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :accounts,
                    :currencies,
                    column: :currency,
                    primary_key: :currency
  end
end
