class Transaction < ApplicationRecord
  belongs_to :operation
  has_one :account
end
