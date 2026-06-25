# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :operation
  has_one :account, dependent: :destroy

  validates :amount, presence: true
end
