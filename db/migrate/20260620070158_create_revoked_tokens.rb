class CreateRevokedTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :revoked_tokens do |t|
      t.timestamps

      t.uuid :jti, null: false
      t.datetime :exp, null: false
    end

    add_index :revoked_tokens, :jti, unique: true
  end
end
