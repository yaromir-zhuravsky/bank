# frozen_string_literal: true

class CreateAdmins < ActiveRecord::Migration[8.1]
  def change
    create_table :admins do |t|
      t.timestamps

      t.bigint :user_id
    end

    add_foreign_key :admins, :users
    add_index :admins, :user_id, unique: true
  end
end
