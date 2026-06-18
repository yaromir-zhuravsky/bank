# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :operation
  has_one :account, dependent: :restrict_with_error
end
