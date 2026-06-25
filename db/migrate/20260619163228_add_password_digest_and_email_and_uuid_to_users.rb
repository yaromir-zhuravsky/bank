class AddPasswordDigestAndEmailAndUuidToUsers < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!
  enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")
  enable_extension "citext" unless extension_enabled?("citext")

  def change
    add_column :users, :password_digest, :string, null: false
    add_column :users, :email, :citext, null: false
    add_column :users, :uuid, :uuid, null: false

    add_index :users, :email, unique: true, algorithm: :concurrently
    add_index :users, :uuid, unique: true, algorithm: :concurrently
  end
end
