# frozen_string_literal: true

class Account < ApplicationRecord
  enum :currency, {
    usd: "USD",
    eur: "EUR",
    pln: "PLN"
  }

  belongs_to :customer
  has_many :transactions, dependent: :restrict_with_error

  validates :number, presence: true, uniqueness: true, format: {with: /\A[0-9]{16}\z/}
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true


  def add!(amount)
    update!(balance: balance + amount)
  end

  def deduct!(amount)
    update!(balance: balance - amount)
  end
end
