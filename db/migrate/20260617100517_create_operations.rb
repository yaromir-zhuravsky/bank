# frozen_string_literal: true

class CreateOperations < ActiveRecord::Migration[8.1]
  def change
    create_table :operations, &:timestamps
  end
end
