# frozen_string_literal: true

class Operation < ApplicationRecord
  has_many :transactions, dependent: :restrict_with_error
end
