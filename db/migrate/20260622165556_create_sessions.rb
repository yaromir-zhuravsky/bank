class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions do |t|
      t.timestamps

      t.references :user, null: false, foreign_key: true, index: false
      t.uuid :uuid, null: false
      t.string :current_refresh_jti, null: false
      t.datetime :expires_at, null: false
      t.datetime :revoked_at
    end


    add_index :sessions, :uuid, unique: true
    add_index :sessions, :current_refresh_jti, unique: true
  end
end
