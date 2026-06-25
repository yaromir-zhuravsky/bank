# frozen_string_literal: true

class Operation < ApplicationRecord
  has_many :transactions, dependent: :destroy
end
