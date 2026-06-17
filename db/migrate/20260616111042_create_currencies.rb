class CreateCurrencies < ActiveRecord::Migration[8.1]
  def change
    create_table :currencies do |t|
      t.timestamps
      t.string :currency, null: false
    end

    add_index :currencies, :currency, unique: true
    add_check_constraint :currencies,
                         "currencies.currency ~ '^[A-Z]{3}$'",
                         name: "chk_currencies_currency_3_uppercase_english_letters"
  end
end
