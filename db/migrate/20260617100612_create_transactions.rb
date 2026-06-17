class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.timestamps

      t.bigint :account_id, null: false
      t.bigint :operation_id, null: false
      t.bigint :amount, null: false
    end

    add_foreign_key :transactions,
                    :operations
    add_foreign_key :transactions,
                    :accounts
  end
end
