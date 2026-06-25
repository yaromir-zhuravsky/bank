class DropRevokedTokens < ActiveRecord::Migration[8.1]
  def change
    drop_table :revoked_tokens
  end
end
